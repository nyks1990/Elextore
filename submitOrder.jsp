<%@include file="Header.jsp"%>

<%
 MongoClient mongo = new MongoClient("52.11.50.218", 27017);
        String address = request.getParameter("address");
           String cardno = request.getParameter("cardNum");
            String validity = request.getParameter("validity");
            String ccv = request.getParameter("ccv");

          HttpSession s=request.getSession();
                            
           list= (List<Cart>) s.getAttribute("list");
            String total=s.getAttribute("total").toString();
           // Map<String, Object> products = new BasicDBObject();
            List<String> cartList = new ArrayList<>();
            
           
            for(Cart cart : list){
          cartList.add(cart.getId());
        
           }

        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
       //get current date time with Date()
      Date date = new Date();
       //System.out.println(dateFormat.format(date));

            DB db = mongo.getDB("Elextore");
            // If the collection does not exists, MongoDB will create it for you
           

            Map<String, Object> commandArguments = new BasicDBObject();
            DBCollection myOrders = db.getCollection("orders");
            
            commandArguments.put("userId", userBean.getId());
            commandArguments.put("userEmail",userBean.getEmail());
            commandArguments.put("total", total);
            //String[] roles = { "readWrite" };
            commandArguments.put("items", cartList);
            commandArguments.put("status", "Progress");
            commandArguments.put("isCancelled", "false");
            commandArguments.put("address", address);
            commandArguments.put("cardNumber", cardno);
            commandArguments.put("validity", validity);
            commandArguments.put("ccv", ccv);
           commandArguments.put("date", dateFormat.format(date));
            
            //commandArguments.put("product", product);
            BasicDBObject doc = new BasicDBObject(commandArguments);
           myOrders.insert(doc);
            Object id = (Object)doc.get( "_id" );
           
            // insert product items
            
            DBCollection orderProducts = db.getCollection("orderItems");
            
                
           for(Cart cart : list){
               // cartList.add(cart.getId());
                 Map<String, Object> commandArguments1 = new BasicDBObject();
                  commandArguments1.put("orderId", id.toString());
                 commandArguments1.put("productId", cart.getId().toString());
                commandArguments1.put("productName", cart.getName());
                  commandArguments1.put("price", cart.getPrice());
                   commandArguments1.put("quantity", cart.getQuantity());
                  commandArguments1.put("imageUrl", cart.getImageUrl());  
                  commandArguments1.put("status", "Progress"); 
                   commandArguments1.put("isCancelled", "false"); 
                   BasicDBObject doc1 = new BasicDBObject(commandArguments1);
                  orderProducts.insert(doc1);
           }

            list.clear();
            total="";
            s.setAttribute("list",list);
            s.setAttribute("total",total);
           
            date.setTime(date.getTime() + 15 * 1000 * 60 * 60 * 24);
                  %>
<body>
<H1 ALIGN="CENTER">Order Placed successfully</H1>
<H3 ALIGN="CENTER">Your Order Id = <%=id.toString()%></H1>
</BODY>
<%@include file="footer.jsp" %>