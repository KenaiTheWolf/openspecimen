
import { format } from 'date-fns';
import useClipboard from 'vue-clipboard3'

import alertSvc from '@/common/services/Alerts.js';
import http from '@/common/services/HttpClient.js';
import exprUtil from '@/common/services/ExpressionUtil.js';


class Util {
  httpsRe = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|])/gim;

  wwwRe   = /(^|[^/])(www\.[\S]+(\b|$))/gim;

  mailRe  = /(([a-zA-Z0-9-_.])+@[a-zA-Z_]+?(\.[a-zA-Z]{2,6})+)/gim;

  toClipboard = useClipboard().toClipboard;

  spmnTypeProps = null;

  fileTypes = [
    'bmp', 'csv', 'css', 'doc', 'docx', 'gif', 'html', 'jar', 'java', 'jpeg', 'jpg',
    'js', 'json', 'pdf', 'png', 'tif', 'tiff', 'txt', 'xls', 'xlsx', 'xml', 'zip'
  ];

  mask = null;


  setMask(mask) {
    this.mask = mask;
  }

  enableMask() {
    if (this.mask) {
      this.mask.enable();
    }
  }

  disableMask() {
    if (this.mask) {
      this.mask.disable();
    }
  }

  clone(obj) {
    if (obj == null || typeof obj != 'object') {
      return obj;
    } else if (obj instanceof Date) {
      let copy = new Date();
      copy.setTime(obj.getTime());
      return copy;
    } else if (obj instanceof Array) {
      return obj.map(elem => this.clone(elem));
    } else if (obj instanceof Object) {
      let copy = {};
      for (let prop in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, prop)) {
          copy[prop] = this.clone(obj[prop]);
        }
      }
      return copy;
    }

    throw new Error("Unrecognised object field.");
  }

  queryString(params) {
    return Object.keys(params || {}).sort().reduce(
      (result, param) => {
        if (result) {
          result += '&';
        }

        if (params[param]) {
          result += param + '=' + params[param];
        }

        return result;
      },
      ''
    );
  }

  uriEncode(params) {
    if (!params || Object.keys(params).length <= 0) {
      return undefined;
    }

    let curatedParams = {};
    for (const [key, value] of Object.entries(params)) {
      if (value || value == 0 || value == false || value == 'false') {
        curatedParams[key] = value;
      }
    }

    let result = undefined;
    if (Object.keys(curatedParams).length > 0) {
      result = btoa(encodeURIComponent(JSON.stringify(curatedParams)));
    }

    return result;
  }

  linkify(text) {
    if (!text) {
      return text;
    }

    return text.replace(this.httpsRe, '<a href="$1" target="_blank">$1</a>')
      .replace(this.wwwRe, '$1<a href="http://$2" target="_blank">$2</a>')
      .replace(this.mailRe, '<a href="mailto:$1">$1</a>');
  }

  getAbsentItems(dstArray, srcArray, keyProp) {
    if (!keyProp) {
      return srcArray;
    }

    const map = dstArray.reduce(
      (acc, obj) => {
        acc[exprUtil.eval(obj, keyProp)] = obj;
        return acc;
      },
      {}
    );

    const result = [];
    for (let obj of srcArray) {
      let key = exprUtil.eval(obj, keyProp);
      if (!map[key]) {
        result.push(obj);
        map[key] = obj;
      }
    }

    return result;
  }

  addIfAbsent(dstArray, srcArray, keyProp) {
    if (!keyProp) {
      return;
    }

    const added = this.getAbsentItems(dstArray, srcArray, keyProp);
    dstArray.push(...added);
    return added;
  }

  validateItems(items, itemLabels, labelProp) {
    // for checking presence of element, using map is faster than list
    const labelsMap = items.reduce(
      (acc, item) => {
        let key = exprUtil.eval(item, labelProp);
        acc[key] = true;
        return acc;
      }, {}
    );

    const found = [], notFound = [];
    itemLabels.forEach(
      (label) => {
        if (labelsMap[label]) {
          found.push(label);
          delete labelsMap[label];
        } else {
          notFound.push(label);
        }
      }
    );

    return { found, notFound, extra: Object.keys(labelsMap) };
  }

  async copyToClipboard(text) {
    return this.toClipboard(text);
  }

  async loadSpecimenTypeProps() {
    const qp = {attribute: 'specimen_type', includeParentValue: true, includeProps: true};
    const resp = await http.get('permissible-values', qp);
    this.spmnTypeProps = resp.reduce(
      (acc, type) => {
        if (type.parentValue) {
          acc[type.parentValue + ':' + type.value] = type.props;
        } else {
          acc[type.value + ':*'] = type.props;
        }

        return acc;
      }
    );

    return this.spmnTypeProps;
  }

  getSpecimenMeasureUnit({specimenClass, type, specimenType}, measure) {
    type = type || specimenType;
    if (!specimenClass || !type) {
      return '-';
    }

    let props = this.spmnTypeProps[specimenClass + ':' + type] || {};
    let unit = this.getUnit(props, measure);
    if (!unit) {
      props = this.spmnTypeProps[specimenClass + ':*'] || {};
      unit = this.getUnit(props, measure);
    }

    return unit || '-';
  }

  getUnit(props, measure) {
    let unit = null;

    switch (measure) {
      case 'quantity':
        unit = props.qtyHtmlDisplayCode || props.quantity_display_unit || props.qtyUnit || props.quantity_unit;
        break;

      case 'concentration':
        unit = props.concHtmlDisplayCode || props.concentration_display_unit || props.concUnit || props.concentration_unit;
        break;
    }

    return unit;
  }

  getContainerColorCode({specimenClass, type, specimenType}) {
    type = type || specimenType;
    if (!specimenClass || !type) {
      return {};
    }

    let props = this.spmnTypeProps[specimenClass + ':' + type] || {};
    if (!props['container_color_code']) {
      props = this.spmnTypeProps[specimenClass + ':*'] || {};
    }

    if (props['container_color_code']) {
      try {
        return JSON.parse(props['container_color_code']);
      } catch (e) {
        console.log('Could not parse the following string into JSON: ' + props['container_color_code']);

        const kvList = props['container_color_code'].split(',');
        const style = {};
        kvList.forEach(
          (kv) => {
            const kvPair = kv.split('=');
            if (!kvPair || kvPair.length <= 1) {
              return;
            }

            style[kvPair[0].trim()] = kvPair[1].trim();
          }
        );

        return style;
      }
    }

    return {};
  }

  isBool(value) {
    return value == true || value == false || value == 'true' || value == 'false';
  }

  isFalse(value) {
    return value == false || value == 'false';
  }

  isTrue(value) {
    return value == true || value == 'true';
  }

  async downloadReport(downloadFn, {msgs = {}, filename = 'report.csv'} = {}) {
    msgs = msgs || {};

    alertSvc.info(msgs.initiated || 'Generating the report. Please wait for a moment...');
    let result = await downloadFn();
    if (result.completed) {
      alertSvc.info(msgs.downloading || 'Downloading the report...');

      let extn = filename.substr(filename.lastIndexOf('.') + 1).toLowerCase();
      if (this.fileTypes.indexOf(extn) == -1) {
        // no known extension, by default, append .csv
        filename += '.csv';
      }

      http.downloadFile(http.getUrl('query/export', {query: {fileId: result.dataFile, filename: filename}}));
    } else if (result.dataFile) {
      alertSvc.info(msgs.emailed || 'Report generation is taking more time than anticipated. Report will be emailed');
    }
  }

  formatDate(date, pattern) {
    if (!(date instanceof Date)) {
      return date;
    }

    return format(date, pattern);
  }

  splitStr(str, re, returnEmpty) {
    const result = [];
    const map = this._getEscapeMap(str);

    let token = '', escUntil = undefined;
    for (let i = 0; i < str.length; ++i) {
      if (escUntil == undefined) {
        escUntil = map[i];
      }

      if (i <= escUntil) {
        token += str[i];
        if (i == escUntil) {
          escUntil = undefined;
        }
      } else {
        if (re.exec(str[i]) == null) {
          token += str[i];
        } else {
          token = this._getToken(token);
          if (token.length > 0 || !!returnEmpty) {
            result.push(token);
          }
          token = '';
        }
      }
    }

    token = this._getToken(token);
    if (token.length > 0) {
      result.push(token);
    }

    return result;
  }

  getDupItems(stringItems) {
    const itemsMap = {}, result = [];
    for (let item of stringItems) {
      let instance = itemsMap[item] || 0;
      if (instance == 1) {
        result.push(item);
      }

      itemsMap[item] = ++instance;
    }

    return result;
  }

  _getEscapeMap(str) {
    let map = {}, insideSgl = false, insideDbl = false;
    let lastIdx = -1;

    for (let i = 0; i < str.length; ++i) {
      if (str[i] == "'" && !insideDbl) {
        if (insideSgl) {
          map[lastIdx] = i;
        } else {
          lastIdx = i;
        }

        insideSgl = !insideSgl;
      } else if (str[i] == '"' && !insideSgl) {
        if (insideDbl) {
          map[lastIdx] = i;
        } else {
          lastIdx = i;
        }

        insideDbl = !insideDbl;
      }
    }

    return map;
  }

  _getToken(token) {
    token = token.trim();
    if (token.length != 0) {
      if ((token[0] == "'" && token[token.length - 1] == "'") ||
        (token[0] == '"' && token[token.length - 1] == '"')) {
        token = token.substring(1, token.length - 1);
      }
    }

    return token;
  }
}

export default new Util();
