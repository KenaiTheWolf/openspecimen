
import arrayJoiner from './ArrayJoin.js';
import boolValue from './BoolValue.js';
import dateFmt from './DateFormatter.js';
import storagePosition from './StoragePosition.js';
import specimenMeasure from './SpecimenMeasure.js';
import user from './User.js';

export default {
  install(app) {
    let filters = app.config.globalProperties.$filters = app.config.globalProperties.$filters || {};
    Object.assign(filters, {
      arrayJoin: arrayJoiner.join,
      boolValue: boolValue.toString,
      date: dateFmt.date,
      dateTime: dateFmt.dateTime,
      specimenMeasure: specimenMeasure.format,
      storagePosition: storagePosition.toString,
      username: user.name
    });
  }
}
