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
font-size: 13px;  
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
  With this email, you confirmed that you have received and reviewed the quantity and quality of the ordered item(s), based on the $document_no$.</p>
<p>
  Please find below the item(s) and your confirmation.
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <thead>
      <tr>
        <td width="40%" align="left" class="tableheader">Item requested</td>
        <td width="10%" align="left" class="tableheader">Quantity requested</td> 
        <td width="10%" align="right" class="tableheader">Quantity received previously</td>
        <td width="10%" align="right" class="tableheader">Quantity Delivered</td>
        <td width="10%" align="left" class="tableheader">Quantity not yet delivered</td>
        <td width="10%" align="left" class="tableheader">Quantity confirmed</td>
        <td width="10%" align="left" class="tableheader">Quantity need to be followed up</td>
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
  </table>
</p>

<p>Thank you,</p>
<p>
Procurement unit
</p>
<p>
  Please do not reply to this message. Replies to this message are routed to an unmonitored mailbox. If you have questions, please contact <a href="mailto: CIFOR-Procurement@cgiar.org">Procurement team </a> unit
</p>