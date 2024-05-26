<style type="text/css">
  <!--
p {   font-family: Verdana, Geneva, sans-serif;   font-size: 10pt;  } 
.basefont {  
font-family: Verdana, Geneva, sans-serif;  
font-size: 10pt;   
border-bottom:#C2D69A solid 1px;    
border-right:#C2D69A solid 1px;    
padding:5px;  } 
 
.zebra {  
background-color: #EAF1DD;  
font-family: Verdana, Geneva, sans-serif;  
font-size: 10pt;   
border-bottom:#C2D69A solid 1px;   
border-right:#C2D69A solid 1px;    
padding:5px;  } 
 
.tableheader {  
font-family: Verdana, Geneva, sans-serif;  
font-size: 10pt;  
background-color: #9BBB59;  
font-weight: bold;  
color: #FFF;   padding:5px;
}  
.tableheader td {
	width:250px;
}
.tableheader2 {  
font-family: Verdana, Geneva, sans-serif;  
font-size: 10pt;  
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
font-size: 10pt;   }
tr.norow td {   border-bottom:none;
font-family: Verdana, Geneva, sans-serif;  
font-size: 10pt;   }
tr.row td:first-child {
	width:250px;
}

.signature{
font-family: Calibri;
font-size: 9pt;
}
-->
</style>
$if(isTest)$
$TO_CC$
$endif$
<p>
  To:
  <br/>$vendor_name$
</p>

<p>Dear $cp_name$,</p>

<p>
I am sending you this email to ask if you could send us a quotation for item(s) with the following detailed specification:
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <thead>
      <tr>
        <td width="5%" align="left" class="tableheader">No</td>
        <td width="50%" align="left" class="tableheader">Description</td>
        <td width="15%" align="right" class="tableheader">Quantity</td>
        <td width="15%" align="left" class="tableheader">UOM</td>
        <td width="15%" align="left" class="tableheader">Price</td>
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
  </table>
</p>
<p>
  Kindly send us your best quotation at the latest by $due_date$.<br/>
  Thank you for your kind attention.
</p>
<p>
  Best regards,
</p>
<p class="signature">
  <b>Procurement Unit</b><br/>
  World Agroforestry (ICRAF)<br/>
  Jalan CIFOR Situ Gede Bogor Barat 16115 Indonesia<br/>
  Tel +62 (0) 251 8622622<br/>
  <a href="http://worldagroforestry.org">worldagroforestry.org</a> | <a href="https://forestsnews.cifor.org">forestsnews.cifor.org</a> | <a href="http://foreststreesagroforestry.org">foreststreesagroforestry.org</a> | <a href="https://twitter.com/icraf">@ICRAF</a> <br/>
    <a href="https://worldagroforestry.org/">
      <img src="https://www.cifor.org/images/ICRAF-logo.png" alt="World Agroforestry (ICRAF) logo.png" style="margin:5px;width:75px;height:55px">
    </a>
    <a href="http://foreststreesagroforestry.org/">
      <img src="http://www.cifor.org/images/cgiar%20logo.png" alt="CGIAR logo.png" style="margin:5px">
    </a><br/>
  World Agroforestry (ICRAF) is <a href="http://cgiar.org">a CGIAR Research Center</a>
</p>