package edu.wustl.catissuecore.bizlogic.magetab;

import edu.wustl.catissuecore.domain.Specimen;

public class EthnicityTransformer extends AbstractCharacteristicTransformer {

	public EthnicityTransformer(CharacteristicTransformerConfig characteristicTransformerConfig) {
		super("Ethnicity", "Ethnicity","Ethnicity", characteristicTransformerConfig);
	}
	
	@Override
	public String getCharacteristicValue(Specimen specimen) {
		return specimen.getSpecimenCollectionGroup().getCollectionProtocolRegistration().getParticipant().getEthnicity();
	}
	
	@Override
	public boolean isMageTabSpec() {
		// TODO Auto-generated method stub
		return true;
	}

}
