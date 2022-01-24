// Name:			ProgressTrailApexAction.apxc
// Author:			Mitch Lynch, Salesforce (mitch.lynch@salesforce.com)
// Created:			27 Dec 2021
// Last Updated:	10 Jan 2022

// Comments:
// 	- Supports the ProgressTrail Aura component.
// 	- getProgressTrailRecord()	:	Retrieves the Progress_Trail__c record, given a unique Name, to determine which object and field will control the ProgressTrail component.
// 	- getCurrentRecordStatus()	:	Retrieves the current value of the picklist field designated on the Progress_Trail__c record, to properly display the progress path.
// 	- getActiveSegment()		:	Retrieves the Progress_Trail_Segment__c record that is currently needed for display in the ProgressTrail component.

//	- 1/10/2022 (Mitch Lynch)	-	Rewriting/fixing Apex to write tests in ProgressTrailCtrlTest.
//	- 1/5/2022 (Mitch Lynch)	-	FINALLY works!  I'm not yet an Apex Predator, but I am an Apex Pirate for certain;
//									Minor clean-up/editing of code comments.
//	- 1/3/2022 (Mitch Lynch)	-	Created initial class by moving createProgressTrailSegments() method out of ProgressTrailCtrl to setup as an Apex Action;
//									Doesn't actually work - haven't figured out how to properly use InvocableVariables yet.


global class ProgressTrailApexAction {
    
    // create Progress Trail Segments related to a given Progress_Trail__c Id
    @InvocableMethod(label='Create Progress Trail Segments')
    global static List < FlowOutputs > showOutputs( List < FlowInputs > inputs ) {
        // Create a new empty list for the draft Progress Trail Segment records
        List<Progress_Trail_Segment__c> segList = new List<Progress_Trail_Segment__c>();
        
        FlowInputs objInput = inputs.get( 0 );
        List < FlowOutputs > outputs = new List < FlowOutputs >();
        FlowOutputs objOutput = new FlowOutputs();
        Id ParamTrailId = objInput.ParamTrailId;
        String ParamInternalActiveGuidanceType = objInput.ParamInternalActiveGuidanceType;
        String ParamExternalActiveGuidanceType = objInput.ParamExternalActiveGuidanceType;
        Boolean ParamPassRecordIdToExternalFlow = objInput.ParamPassRecordIdToExternalFlow;
        Boolean ParamPassRecordIdToInternalFlow = objInput.ParamPassRecordIdToInternalFlow;
        
        // Get the Progress_Trail__c record
        Progress_Trail__c t = [SELECT Id,Related_Object_API_Name__c,Status_Field_API_Name__c
                               FROM Progress_Trail__c 
                               WHERE Id = :ParamTrailId LIMIT 1];
        
        // Create a list of picklist value records from a SOQL query
        PicklistValueInfo[] pvalues = [SELECT Label,Value
                                       FROM PicklistValueInfo
                                       WHERE EntityParticle.EntityDefinition.QualifiedApiName = :t.Related_Object_API_Name__c
                                       AND EntityParticle.DeveloperName = :t.Status_Field_API_Name__c
                                       AND isActive = true LIMIT 100];
        
        // Loop through the list and build all Progress Trail Segment records
        for(PicklistValueInfo p : pvalues){
            Progress_Trail_Segment__c seg = new Progress_Trail_Segment__c(
                Name = p.Label,
                Progress_Trail__c = t.Id,
                Internal_Guidance_Text__c = 'This is the rich text guidance for the <b>' + p.Label + '</b> status value. It is only visible to <u>Internal</u> users.',
                External_Guidance_Text__c = 'This is the rich text guidance for the <b>' + p.Label + '</b> status value. It is only visible to <u>External</u> users.',
            	Internal_Guidance_Active_Type__c = ParamInternalActiveGuidanceType,
            	External_Guidance_Active_Type__c = ParamExternalActiveGuidanceType,
            	Pass_RecordId_to_External_Flow_if_Active__c = ParamPassRecordIdToExternalFlow,
                Pass_RecordId_to_Internal_Flow_if_Active__c = ParamPassRecordIdToInternalFlow);
            
            segList.add(seg);
        }
        
        // Update the database to create the new Progress Trail Segment records
        upsert segList;
        
        objOutput.segList = segList;
        outputs.add ( objOutput );
        return outputs;
    }
    
    // Setup input variables to pass from the flow
    global class FlowInputs {
        @InvocableVariable (label='Progress Trail RecordId' description='Id for the Progress_Trail__c record.' required='true')
        global Id ParamTrailId;
        
        @InvocableVariable (label='Active Guidance Type (for Internal Users)' description='Default value to use for Internal_Active_Guidance_Type__c when creating new Progress Trail Segments.' required='true')
        global String ParamInternalActiveGuidanceType;
        
        @InvocableVariable (label='Active Guidance Type (for External Users)' description='Default value to use for External_Active_Guidance_Type__c when creating new Progress Trail Segments.' required='true')
        global String ParamExternalActiveGuidanceType;
        
        @InvocableVariable (label='Pass RecordId to External Flow, if Active?' description='When checked and the external guidance type is set to Flow, the current record Id will be passed to the designated Flow as an input variable called recordId.' required='true')
        global Boolean ParamPassRecordIdToExternalFlow;
        
        @InvocableVariable (label='Pass RecordId to External Flow, if Active?' description='When checked and the external guidance type is set to Flow, the current record Id will be passed to the designated Flow as an input variable called recordId.' required='true')
        global Boolean ParamPassRecordIdToInternalFlow;
    }
    
    // Setup output variable(s) to pass back to the flow
    global class FlowOutputs {
        @InvocableVariable (label='Progress Trail Segment Record Collection' description='Progress_Trail_Segment__c records created by the Apex action.')
        global List<Progress_Trail_Segment__c> segList;
    }
    
    // resource:  https://developer.salesforce.com/docs/atlas.en-us.234.0.apexcode.meta/apexcode/apex_classes_annotation_InvocableVariable.htm
    // resource:  https://www.infallibletechie.com/2020/05/invocablevariable-example-in-salesforce.html
}