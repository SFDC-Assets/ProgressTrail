({
    init : function(cmp, evt) {
        var flow = cmp.find("trailFlow");
		var flowname = cmp.get("v.trailFlowName");
        var passid = cmp.get("v.trailPassRecordIdToFlow");
        var rec = cmp.get("v.recordId");
        
        if (passid) {
            // pass recordId to the flow as an input variable
            var inputVariables = [{
                name : 'recordId',
                type : 'String',
                value : rec
            }];
            
            flow.startFlow(flowname, inputVariables);
        }
        else {
            // don't pass the recordId to the flow as an input variable
            flow.startFlow(flowname);
        }
    },
    
    // reloads page when flow finishes
    refreshPage : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {
            // refresh the page
            $A.get('e.force:refreshView').fire();
        }
    }
})