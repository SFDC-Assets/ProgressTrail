({
    // actions to take as the component loads
    doInit : function(cmp, evt) {
        
        var trailName = cmp.get("v.TrailName");
        
        if(trailName !=null && trailName !='') {
            
            // Get Progress Trail record
            var gettrail = cmp.get("c.getTrail");
            gettrail.setParams({
                ParamTrailName : cmp.get("v.TrailName")
            });
            gettrail.setCallback(this, function(data) {
                var returnedtrail = data.getReturnValue();
                if(returnedtrail !=null && returnedtrail !='') {
                    cmp.set("v.TrailStatusField", returnedtrail[0].Status_Field_API_Name__c);
                }
            });
            console.log("Call Apex gettrail");
            $A.enqueueAction(gettrail);
            
            
            // Get Current Status value for the record
            console.log("Start: query getstatus");
            var getstatus = cmp.get("c.getStatus");
            getstatus.setParams({
                ParamTrailName : cmp.get("v.TrailName"),
                ParamRecordId : cmp.get("v.recordId")
            });
            
            // Get current record's value for the selected status field
            // and then query for the right Trail Segment to display
            getstatus.setCallback(this, function(data) {
                cmp.set("v.CurrentRecordStatus", data.getReturnValue());
                
                console.log("Start: query getactivesegment");
                var getactivesegment = cmp.get("c.getActiveSegment");
                getactivesegment.setParams({
                    ParamTrailName : cmp.get("v.TrailName"),
                    ParamActiveStatus : cmp.get("v.CurrentRecordStatus")
                });
                
                console.log("TrailName is "+cmp.get("v.TrailName"));
                console.log("CurrentRecordStatus is "+cmp.get("v.CurrentRecordStatus"));
                
                getactivesegment.setCallback(this, function(data) {
                    cmp.set("v.TrailSegmentRecord", data.getReturnValue());
                    console.log(data.getReturnValue());
                });
                console.log("Call Apex getactivesegment");
                $A.enqueueAction(getactivesegment);
                console.log("End: query getactivesegment");
            });
            console.log("Call Apex getstatus");
            $A.enqueueAction(getstatus);
            console.log("End: query getstatus");
            
        }
    },
    
    toggleTrailGuidance : function (cmp, evt) {
        var toggleval = cmp.get("v.TrailExpand");
        cmp.set('v.TrailExpand', !toggleval);
    },
    
    // actions to take when a path step is clicked
    handleSelect : function (cmp, evt) {
        var stepName = evt.getParam("detail").value;
        console.log("Selected stepName is "+stepName);
        
        var getactivesegment = cmp.get("c.getActiveSegment");
        getactivesegment.setParams({
            ParamTrailName : cmp.get("v.TrailName"),
            ParamActiveStatus : stepName
        });
        getactivesegment.setCallback(this, function(data) {
            cmp.set("v.TrailSegmentRecord", data.getReturnValue());
            console.log(data.getReturnValue());
        });
        console.log("Call Apex getactivesegment");
        $A.enqueueAction(getactivesegment);
    }
})