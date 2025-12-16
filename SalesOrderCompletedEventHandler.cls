
public class SalesOrderCompletedEventHandler {
    public void doAfterInsert(List<SalesOrderCompleted__e> newList){
        processcompletedOrder(newList);
        
    }
    
    void processcompletedOrder(List<SalesOrderCompleted__e> newList){
        try{
            if(newList.size()>0){
                List<Order> orderlisttoupdate = new List<Order>();
                for(SalesOrderCompleted__e eachcompletedorder:newList){
                    if(String.isNotBlank(String.valueOf(eachcompletedorder.header_created__c)) && String.isNotEmpty(String.valueOf(eachcompletedorder.header_created__c))){
                        String ordernumber = 'Omni_'+eachcompletedorder.pl_header_orderId__c;
                        List<Order> orderlist = new List<Order>();
                        orderlist = [Select Last_Message_Timestamp1__c,Status,Status_Text__c from Order Where Unique_External_Order_Number__c=:ordernumber];
                        Order eachorder = new Order();
                        if(orderlist.size()>0){
                            eachorder = orderlist[0];
                        }else{
                            eachorder=null;
                        }
                        
                        if(eachorder!=Null){
                          
                            if(eachcompletedorder.header_created__c>eachorder.Last_Message_Timestamp1__c){
                                eachorder.Status = eachcompletedorder.pl_state__c;
                                eachorder.Status_Text__c = eachcompletedorder.pl_status__c;
                                orderlisttoupdate.add(eachorder);
                            }
                        }
                      
                    }
                    
                    
                }
                if(orderlisttoupdate.size()>0){
                    Map<id,Order> orderupdatemap = new Map<id,Order>();
                    orderupdatemap.putall(orderlisttoupdate);
                    update orderupdatemap.values();
                }
            }
            
        }catch(Exception ex) {
     
           System.debug('SalesOrdercompletedEventHandler.doAfterInsert'+ex.getMessage()+' '+ex.getLineNumber());
            
        }
    }
}
