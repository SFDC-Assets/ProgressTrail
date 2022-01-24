@isTest
public with sharing class ProgressTrailCtrlTest {
    
    @TestSetup
    public static void makeData(){
        
        // create progress trail and segments
        
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
        
        
        // create Progress Trail Segments for the above trails for these fields in the SOQL:
        // Name, Progress_Trail__c,
        // External_Guidance_Active_Type__c, External_Guidance_Flow_API_Name__c, External_Guidance_Text__c, Pass_RecordId_to_External_Flow_if_Active__c,
        // Internal_Guidance_Active_Type__c, Internal_Guidance_Flow_API_Name__c, Internal_Guidance_Text__c, Pass_RecordId_to_Internal_Flow_if_Active__c
        List<Progress_Trail_Segment__c> segmentList = new List<Progress_Trail_Segment__c>();
        
        Progress_Trail_Segment__c segment01a = new Progress_Trail_Segment__c(
            Name										= 'New',
            Progress_Trail__c							= trail01.Id,
            External_Guidance_Active_Type__c			= 'Display Rich Text',
            External_Guidance_Flow_API_Name__c			= '',
            External_Guidance_Text__c					= 'This is the sample New status text for the external audience.',
            Pass_RecordId_to_External_Flow_if_Active__c	= true,
            Internal_Guidance_Active_Type__c			= 'Display Rich Text',
            Internal_Guidance_Flow_API_Name__c			= '',
            Internal_Guidance_Text__c					= 'This is the sample New status text for the internal audience.',
            Pass_RecordId_to_Internal_Flow_if_Active__c	= true
        );
        segmentList.add(segment01a);
        
        Progress_Trail_Segment__c segment01b = new Progress_Trail_Segment__c(
            Name										= 'Closed',
            Progress_Trail__c							= trail01.Id,
            External_Guidance_Active_Type__c			= 'Display Rich Text',
            External_Guidance_Flow_API_Name__c			= '',
            External_Guidance_Text__c					= 'This is the sample New status text for the external audience.',
            Pass_RecordId_to_External_Flow_if_Active__c	= true,
            Internal_Guidance_Active_Type__c			= 'Display Rich Text',
            Internal_Guidance_Flow_API_Name__c			= '',
            Internal_Guidance_Text__c					= 'This is the sample New status text for the internal audience.',
            Pass_RecordId_to_Internal_Flow_if_Active__c	= true
        );
        segmentList.add(segment01b);
        
        Progress_Trail_Segment__c segment02a = new Progress_Trail_Segment__c(
            Name										= 'Web',
            Progress_Trail__c							= trail02.Id,
            External_Guidance_Active_Type__c			= 'Display Rich Text',
            External_Guidance_Flow_API_Name__c			= '',
            External_Guidance_Text__c					= 'This is the sample New status text for the external audience.',
            Pass_RecordId_to_External_Flow_if_Active__c	= true,
            Internal_Guidance_Active_Type__c			= 'Display Rich Text',
            Internal_Guidance_Flow_API_Name__c			= '',
            Internal_Guidance_Text__c					= 'This is the sample New status text for the internal audience.',
            Pass_RecordId_to_Internal_Flow_if_Active__c	= true
        );
        segmentList.add(segment02a);
        
        Progress_Trail_Segment__c segment02b = new Progress_Trail_Segment__c(
            Name										= 'Other',
            Progress_Trail__c							= trail02.Id,
            External_Guidance_Active_Type__c			= 'Display Rich Text',
            External_Guidance_Flow_API_Name__c			= '',
            External_Guidance_Text__c					= 'This is the sample New status text for the external audience.',
            Pass_RecordId_to_External_Flow_if_Active__c	= true,
            Internal_Guidance_Active_Type__c			= 'Display Rich Text',
            Internal_Guidance_Flow_API_Name__c			= '',
            Internal_Guidance_Text__c					= 'This is the sample New status text for the internal audience.',
            Pass_RecordId_to_Internal_Flow_if_Active__c	= true
        );
        segmentList.add(segment02b);
        
        insert segmentList;
    }
    
    
    // Tests for: getTrail()
    
    
    @isTest
    public static void getTrail_testPositive(){
        
        // set trail name
        String trailName = 'Test Case Status';
        
        Test.startTest();
        List<Progress_Trail__c> trailList  = ProgressTrailCtrl.getTrail(trailName);
        Test.stopTest();
        
        system.assert(trailList.isEmpty() == false);
        system.assert(trailList.size() == 1);
    }
    
    @isTest
    public static void getTrail_testNegative(){
        
        // set trail name
        String trailName = 'Test Lead Status';
        
        Test.startTest();
        List<Progress_Trail__c> trailList  = ProgressTrailCtrl.getTrail(trailName);
        Test.stopTest();
        
        system.assert(trailList.size() == 0);
    }
    
    
    // Tests for: getStatus()
    
    
    @isTest
    public static void getStatus_testPositive(){
        
        // set trail name
        String trailName = 'Test Case Status';
        
        // create cases
        List<Case> caseListInsert = new List<Case>();
        
        Case case01 = new Case(
            Status				= 'New',
            Subject				= 'Case01'
        );
        caseListInsert.add(case01);
        insert caseListInsert;
        
        Test.startTest();
        String curStatus = ProgressTrailCtrl.getStatus(trailName,case01.Id);
        Test.stopTest();
        
        system.assert(String.isBlank(curStatus) == false);
        // system.assert(curStatus == case01.Status,'curStatus is ' + curStatus + ' and trailName is ' + trailName + ' and case01.Id is ' + case01.Id);
    }
    
    @isTest
    public static void getStatus_testNegative(){
        
        // set trail name for non-existent trail
        String trailName = 'Test Contract Status';
        
        // create cases
        List<Case> caseListInsert = new List<Case>();
        
        Case case01 = new Case(
            Status				= 'New',
            Subject				= 'Case01'
        );
        caseListInsert.add(case01);
        insert caseListInsert;
        
        Test.startTest();
        String curStatus = ProgressTrailCtrl.getStatus(trailName,case01.Id);
        Test.stopTest();
        
        system.assert(String.isBlank(curStatus) == true);
    }
    
    
    // Tests for: getActiveSegment()
    
    
    @isTest
    public static void getActiveSegment_testPositive(){
        
        // set trail name
        String trailName = 'Test Case Status';
        
        // set active status for trail
        String activeStatus = 'New';
        
        Test.startTest();
        List<Progress_Trail_Segment__c> segList = ProgressTrailCtrl.getActiveSegment(trailName,activeStatus);
        Test.stopTest();
        
        system.assert(segList.isEmpty() == false);
        system.assert(segList.size() == 1);
    }
    
    @isTest
    public static void getActiveSegment_testNegative(){
        
        // set trail name for non-existent trail
        String trailName = 'Test Contract Status';
        
        // set active status for non-existent trail
        String activeStatus = 'Signed';
        
        Test.startTest();
        List<Progress_Trail_Segment__c> segList = ProgressTrailCtrl.getActiveSegment(trailName,activeStatus);
        Test.stopTest();
        
        system.assert(segList.size() == 0);
    }
    
}