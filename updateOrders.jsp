<%@include file="Header.jsp" %>

<%
MongoClient mongo = new MongoClient("52.11.50.218", 27017);     
        HttpSession s=request.getSession();
       
        Boolean isCancelled=false;         

        DB db = mongo.getDB("Elextore");
       String cancelOrder=request.getParameter("cancelOrder");
        String cancelProduct=request.getParameter("cancelProduct");
       String orderId= request.getParameter("orderId");
        System.out.println("Order 0----- "+cancelOrder);
         if(cancelOrder!=null)
         {
            if(cancelOrder.equals("cancelOrder"))
            {

                //String orderId= request.getParameter("orderId");
                String stat= request.getParameter("delivery");
                if(stat.equals("Delivered"))
                {
                  isCancelled=true;
                }
                else
                {
                  ObjectId objid =new ObjectId(orderId);
                    DBCollection orders = db.getCollection("orders");
                    BasicDBObject newDocument = new BasicDBObject();
                    newDocument.append("$set", new BasicDBObject().append("isCancelled", "true"));
                    newDocument.append("$set", new BasicDBObject().append("status", "Cancelled"));
                    BasicDBObject searchQuery = new BasicDBObject().append("_id", objid);

                    orders.update(searchQuery, newDocument);
                }
                
                    }
            }
              
            //Cancel product
            if(cancelProduct!=null)
         {
            if(cancelProduct.equals("cancelProduct"))
            {

                String orderItemId= request.getParameter("orderItemId");
                String stat= request.getParameter("delivery");
                if(stat.equals("Delivered"))
                {
                  isCancelled=true;
                }
                else
                {
                  ObjectId objid =new ObjectId(orderItemId);
                    DBCollection orders = db.getCollection("orderItems");
                    BasicDBObject newDocument = new BasicDBObject();
                    newDocument.append("$set", new BasicDBObject().append("isCancelled", "true"));
                    newDocument.append("$set", new BasicDBObject().append("status", "Cancelled"));
                    BasicDBObject searchQuery = new BasicDBObject().append("_id", objid);

                    orders.update(searchQuery, newDocument);
                }
                
                    }
            }
            ObjectId objid =new ObjectId(orderId);
            
            DBCollection collection = db.getCollection("orders");
            BasicDBObject whereQuery = new BasicDBObject();
            whereQuery.put("_id", objid);
           // whereQuery.put("userId", userBean.getId());
           // BasicDBObject whereQuery1 = new BasicDBObject();
            //whereQuery.put("password", pwd);
            DBCursor cursor = collection.find(whereQuery);
            
            DBCollection collection1 = db.getCollection("orderItems");
            


                  %>
<body style="z-index=-1">
<div class="well">
    <div class="row">
             <%
          if(isCancelled==true)
          {%>
         <h2>Order cannot be cancelled</h2>

         <% }
         %>
            <div class="row">
                <div class="col-lg-10"><h3 >Order Details Update</p> </div>
                <div class="col-lg-2"> 
                
                </div>
            </div>
            

            <div class="row">
                <div class="col-lg-12">
                     <table class="table table-striped">
                        <tr>
                       <!--  <th>Name</th>
                    <th>Image</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Action</th>
                    <th>Action</th> -->
                        </tr>
                          <%
  while(cursor.hasNext()) {
                    BasicDBObject obj = (BasicDBObject) cursor.next();
                  //  Object orderId=(Object)obj.get("_id");
                    BasicDBList itemsList = (BasicDBList) obj.get("items");
                  //  System.out.println("orderrrr"+orderId.toString());
              %>
               
<tr><td><h3>Order Id : <%=orderId.toString()%></h3></td></tr>
<%
    String iscan=(String)obj.get("status");
                if(iscan.equals("Cancelled"))
                { 
                %>
                     <td>
                   Cancelled
                </td>
                
               <%
                }else
                {
                %>
                   
                
              <%
                }
                %>

                <td>
                   <form class = 'submit-button' method = 'get' action = 'updateOrders.jsp'>
                  
                   <input type='hidden' name = 'orderId' value = '<%=orderId.toString()%>'>
                   <input type='hidden' name = 'updateOrder' value = 'updateOrder'>
                <input type='submit' class="btn btn-danger" value = 'Update Order'>
                </form>
                </td>
                 <td>User : <%=obj.get("userEmail")%></td>
                  <td>Total Price : <%=obj.get("total")%></td>
                        <tr>

<%
        BasicDBObject whereQuery1 = new BasicDBObject();   
       //   ObjectId objid1 =new ObjectId(orderId.toString());
         whereQuery1.put("orderId", orderId.toString());    
            DBCursor cursor1 = collection1.find(whereQuery1);
           while(cursor1.hasNext())
            {

            BasicDBObject obj1 = (BasicDBObject) cursor1.next();
               //Integer id=productIterator.next();
               Object pid=(Object)obj1.get("_id");
               // System.out.println("itemorderrr "+pid.toString());
               String pName=(String)obj1.get("productName");
                String imageUrl=(String)obj1.get("imageUrl");
              // System.out.println("77777### "+pName+ " "+pid+" "+itemsList.get(i));
               // if(pid.toString().equals(itemsList.get(i)))
              //  {

                %>
                   <td><%=pName%></td>
                   <td><img src='<%=imageUrl%>' alt="No Image found for this product" width="250" height="238"></td>
                   <td>
                   <%=obj.get("date")%>
                </td>
                <td>
                   <select class="form-control" id="myselect" name="newQuantity">
                                  <% if((Integer)obj1.get("quantity")==1) {%> <option value="1" selected>1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    <option value="5">5</option> <%}%>
                                  <% if((Integer)obj1.get("quantity")==2) {%><option value="1" selected>1</option> 
                                                            <option value="2" selected>2</option>
                                                            <option value="3">3</option>
                                                            <option value="4">4</option>
                                                            <option value="5">5</option> <%}%>
                                  <% if((Integer)obj1.get("quantity")==3) {%> <option value="1">1</option>
                                                            <option value="2">2</option>
                                                            <option value="3" selected>3</option>
                                                            <option value="4">4</option>
                                                            <option value="5">5</option> <%}%>
                                  <% if((Integer)obj1.get("quantity")==4) {%> <option value="1">1</option>
                                                        <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4" selected>4</option>
                                                    <option value="5">5</option> <%}%>
                                  <% if((Integer)obj1.get("quantity")==5) {%> <option value="1">1</option>
                                                <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5" selected>5</option> <%}%>
                                   
                                </select>
                </td>

              <td>
              
                <select class="form-control" id="myselect" name="newQuantity">
                                  <% if(obj1.get("status").equals("Progress")) {%> <option value="Progress" selected>Progress</option>
                                                    <option value="Cancelled">Cancelled</option>
                                                    <option value="Delivered">Delivered</option>
                                                     <%}%>
                                  <% if(obj1.get("status").equals("Cancelled")) {%><option value="Progress">Progress</option> 
                                                            <option value="Cancelled" selected>Cancelled</option>
                                                            <option value="Delivered">Delivered</option>
                                                             <%}%>
                                  <% if(obj1.get("status").equals("Delivered")) {%> <option value="Progress">Progress</option>
                                                            <option value="Cancelled">Cancelled</option>
                                                            <option value="Delivered" selected>Delivered</option>
                                                             <%}%>
                                 
                                   
                                </select>
                </td>
          <td>
                   <form class = 'submit-button' method = 'get' action = 'updateOrders.jsp'>
                  
                   <input type='hidden' name = 'orderItemId' value = '<%=pid.toString()%>'>
                   <input type='hidden' name = 'updateOrder' value = 'updateOrder'>
                <input type='submit' class="btn btn-danger" value = 'Update Order'>
                </form>
                </td>
                
            </tr>
 <%

}
%>
               

              <%  
                
            }
           
%>



                                    
                 
                    </table>

                </div>
               
            </div>

            
            
    </div>
</div>
<body>
<%@include file="footer.jsp" %>