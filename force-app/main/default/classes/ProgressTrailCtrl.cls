// Name:			ProgressTrailCtrl.apxc
// Author:			Mitch Lynch
// Created:			27 Dec 2021
// Last Updated:	10 Jan 2022

// Comments:
// 	- Supports the ProgressTrail Aura component.
// 	- getProgressTrailRecord()	:	Retrieves the Progress_Trail__c record, given a unique Name, to determine which object and field will control the ProgressTrail component.
// 	- getCurrentRecordStatus()	:	Retrieves the current value of the picklist field designated on the Progress_Trail__c record, to properly display the progress path.
// 	- getActiveSegment()		:	Retrieves the Progress_Trail_Segment__c record that is currently needed for display in the ProgressTrail component.

//	- 01/10/2022 (Mitch Lynch)	-	Rewriting/fixing Apex to write tests in ProgressTrailCtrlTest.
//	- 01/06/2022 (Mitch Lynch)	-	Modified getProgressTrailRecord() to better support writing test coverage.
//	- 01/05/2022 (Mitch Lynch)	-	Minor clean-up / editing code comments.
//									Adding support 
//	- 01/03/2022 (Mitch Lynch)	-	Moving createProgressTrailSegments() method to a dedicated class to setup as an Apex Action.
//	- 12/30/2021 (Mitch Lynch)  -	Finishing up initial build.
//	- 12/27/2021 (Mitch Lynch)	-	Created initial class.

public class ProgressTrailCtrl {
    // Queries for the active picklist values
    // for the user-specified picklist field
    
    // References:
    // https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_picklistvalueinfo.htm
    // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_loops_for_SOQL.htm
    // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_dml_examples_insert_update.htm
    // https://developer.salesforce.com/forums/?id=906F0000000Asg8IAC
    
    public string strfld { get; set; }
    
    // get Progress Trail record based on Name field
    @AuraEnabled
    public static List<Progress_Trail__c> getTrail(String ParamTrailName){
        List<Progress_Trail__c> trailList = new List<Progress_Trail__c>();
        
        if(ParamTrailName != null && ParamTrailName !='') {
            trailList = [SELECT Id,Related_Object_API_Name__c,Status_Field_API_Name__c
                         FROM Progress_Trail__c 
                         WHERE Name = :ParamTrailName LIMIT 1];
        }
        
        return trailList;
    }
    
    
    // Returns the current value of the field used to display the Path
    // given the Object, Field, and Record
    // resource:  https://salesforce.stackexchange.com/questions/118656/soql-dynamic-query-on-objects-dynamic-sobject-name-in-soql
    // 
    @AuraEnabled
    public static String getStatus(String ParamTrailName, ID ParamRecordId){
        
        String finalValue;
        
        if(String.isNotEmpty(ParamTrailName) && String.isNotEmpty(ParamRecordId)) {
            
            String midValue;
            
            // Get the Progress_Trail__c record
            List<Progress_Trail__c> tList = [SELECT Related_Object_API_Name__c,Status_Field_API_Name__c
                                   FROM Progress_Trail__c 
                                   WHERE Name = :ParamTrailName LIMIT 1];
            
            if(tList.size() > 0) {
                
                // Get the current value of the status field for the current record
                ID strrec = ParamRecordId;
                String strobj = tList[0].Related_Object_API_Name__c;
                String strfld = tList[0].Status_Field_API_Name__c;
                String strquery = 'SELECT '+strfld+' FROM '+strobj+' WHERE Id =:ParamRecordId';
                
                List<sObject> myvalue = Database.query(strquery);
                
                String firstValue;
                
                for(sObject so : myvalue){
                    firstValue = (String)so.get(strfld);
                }
                
                midValue = firstValue;
            }
            
            finalValue = midValue;
        }
        
        // String mval = String.valueOf(myvalue);
        return finalValue;
    }
    
    
    // Returns a specific Progress_Trail_Segment__c record
    // for a selected stepName and Progress_Trail__c Id
    @AuraEnabled
    public static List<Progress_Trail_Segment__c> getActiveSegment(String ParamTrailName, String ParamActiveStatus){
        
        List<Progress_Trail_Segment__c> segList = new List<Progress_Trail_Segment__c>();
        
        if(String.isNotEmpty(ParamTrailName) && String.isNotEmpty(ParamActiveStatus)) {
            
            // Get the Progress_Trail__c record
            List<Progress_Trail__c> tList = [SELECT Id
                                             FROM Progress_Trail__c 
                                             WHERE Name = :ParamTrailName LIMIT 1];
            
            if(tList.size() > 0) {
                
                segList = [SELECT Id,Name,External_Guidance_Active_Type__c,External_Guidance_Flow_API_Name__c,External_Guidance_Text__c,Internal_Guidance_Active_Type__c,Internal_Guidance_Flow_API_Name__c,Internal_Guidance_Text__c,Progress_Trail__c,Pass_RecordId_to_External_Flow_if_Active__c,Pass_RecordId_to_Internal_Flow_if_Active__c
                           FROM Progress_Trail_Segment__c
                           WHERE Progress_Trail__c = :tList[0].Id
                           AND Name = :ParamActiveStatus];
            }
            
        }
        
        return segList;
    }
}