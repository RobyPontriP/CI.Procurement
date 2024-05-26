<style type="text/css">
  <!--
p {   font-family: Verdana, Geneva, sans-serif;   font-size: 12px;  } 
.basefont {  
font-family: Verdana, Geneva, sans-serif;  
font-size: 12px;   
border-bottom:#C2D69A solid 1px;    
border-right:#C2D69A solid 1px;    
padding:5px;  } 
 
.zebra {  
background-color: #EAF1DD;  
font-family: Verdana, Geneva, sans-serif;  
font-size: 12px;   
border-bottom:#C2D69A solid 1px;   
border-right:#C2D69A solid 1px;    
padding:5px;  } 
 
.tableheader {  
font-family: Verdana, Geneva, sans-serif;  
font-size: 14px;  
background-color: #9BBB59;  
font-weight: bold;  
color: #FFF;   padding:5px;
}  
.tableheader td {
	width:250px;
}
.tableheader2 {  
font-family: Verdana, Geneva, sans-serif;  
font-size: 12px;  
background-color: #9BBB59;  
font-weight: bold;   color: #FFF;   padding:5px;  } 
 
table {   
border-top:#C2D69A solid 1px;   
border-left:#C2D69A solid 1px;   
border-bottom:#C2D69A solid 1px;   
border-right:#C2D69A solid 1px;   } 
 
tr{   border-bottom:#C2D69A solid 1px;  } 
tr.row td {   border-bottom:#C2D69A solid 1px;
font-family: Verdana, Geneva, sans-serif;  
font-size: 12px;   }
tr.norow td {   border-bottom:none;
font-family: Verdana, Geneva, sans-serif;  
font-size: 12px;   }
tr.row td:first-child {
	width:250px;
}
-->
</style>
$if(isTest)$
$TO_CC$
$endif$
<p>Dear $requester$,</p>
<p>
  The item(s) you requested has been delivered by business partner.
  <br/>
  Please confirm in terms of specification, quantity, and quality of the items listed below.
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <thead>
      <tr>
        <td width="20%" align="left" class="tableheader">Item code</td>
        <td width="50%" align="left" class="tableheader">Description</td> 
        <td width="15%" align="right" class="tableheader">Quantity requested</td>
        <td width="15%" align="right" class="tableheader">Quantity delivered</td>
        <td width="15%" align="left" class="tableheader">Unit</td>
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
  </table>
</p>
<p>
  Click <a href="https://my.cifor.org/workspace/default.aspx">here</a> to go to the item(s) confirmation page in myCIFOR.<br/>
  If you do not confirm within 2 working days after this notification received, the system will automatically confirm the items.
</p>
<p>
  Should you have any questions kindly contact $footer$
</p>
<p>Thank you,
<br/>Procurement unit
</p>
<p>
  Please do not reply to this message. Replies to this message are routed to an unmonitored mailbox.
</p>