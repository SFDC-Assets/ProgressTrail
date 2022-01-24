@isTest
public with sharing class ProgressTrailApexActionTest {
    
    @isTest
    public static void testPositive(){
        
        // create progress trail for these fields in the SOQL:
        // SELECT Name, Related_Object_API_Name__c, Status_Field_API_Name__c
        List<Progress_Trail__c> trailList = new List<Progress_Trail__c>();
        
        Progress_Trail__c trail01 = new Progress_Trail__c(
            Name							= 'Test Case Status',
            Related_Object_API_Name__c		= 'Case',
            Status_Field_API_Name__c		= 'Status'
        );
        trailList.add(trail01);
        
        Progress_Trail__c trail02 = new Progress_Trail__c(
            Name							= 'Test Account Source',
            Related_Object_API_Name__c		= 'Account',
            Status_Field_API_Name__c		= 'AccountSource'
        );
        trailList.add(trail02);
        
        insert trailList;
        
        
        // set Flow input variables
        
        // create a map for input variables
        ProgressTrailApexAction.FlowInputs inputObj = new ProgressTrailApexAction.FlowInputs();
        
        // Progress_Trail__c record Id
        inputObj.ParamTrailId = trail01.Id;
        
        // Active Guidance Type (for Internal Users)
        // Default value to use for Internal_Active_Guidance_Type__c when creating new Progress Trail Segments.
        inputObj.ParamInternalActiveGuidanceType = 'Display Rich Text';
        
        // Active Guidance Type (for External Users)
        // Default value to use for External_Active_Guidance_Type__c when creating new Progress Trail Segments.
        inputObj.ParamExternalActiveGuidanceType = 'Display Rich Text';
        
        // Pass RecordId to External Flow, if Active?
        // When checked and the external guidance type is set to Flow, the current record Id will be passed to the designated Flow as an input variable called recordId.
        inputObj.ParamPassRecordIdToExternalFlow = true;
        
        // Pass RecordId to External Flow, if Active?
        // When checked and the external guidance type is set to Flow, the current record Id will be passed to the designated Flow as an input variable called recordId.
        inputObj.ParamPassRecordIdToInternalFlow = true;
        
        
        // Tests for: getTrail()
        
        Test.startTest();
        List<ProgressTrailApexAction.FlowOutputs> segList = ProgressTrailApexAction.showOutputs(new List<ProgressTrailApexAction.FlowInputs>{inputObj});
        Test.stopTest();
        
        system.assert(segList.isEmpty() == false);
        system.assert(segList.size() > 0);
    }
    
}