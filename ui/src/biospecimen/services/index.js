import cpSvc          from './CollectionProtocol.js';
import cartSvc        from './SpecimenCart.js';
import consentStmtSvc from './ConsentStatement.js';
import folderSvc      from './SpecimenCartsFolder.js';
import specimenSvc    from './Specimen.js';

export default {
  install(app) {
    let osSvc = app.config.globalProperties.$osSvc = app.config.globalProperties.$osSvc || {};
    Object.assign(osSvc, {
      cpSvc         : cpSvc,
      cartSvc       : cartSvc,
      cartFolderSvc : folderSvc,
      consentStmtSvc: consentStmtSvc,
      specimenSvc   : specimenSvc
    });
  }
}
