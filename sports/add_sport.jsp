<!DOCTYPE html>

<html>

<head>
	<title> Add New Sport </title>

	<%
		if(session.getAttribute("userName") == null) {
	%>
		<script type= "text/javascript"> window.location.href = 'index.html'; </script>
	<%
		}
	%>

	<script type="text/javascript">
	function addSubs()
	{
    	var number = document.getElementById("subs").value;

    	var cname, pname, price;

	    var categories = document.createElement("td");
	    categories.align = "center";

	    var elem = document.getElementById('dummy');

	    var str = "";

	    for (var i = 0; i < number; i++)
	    {
	    	cname = "Category " + (i + 1);
	    	pname = "Players_in_cat " + (i + 1);
	    	price = "Price " + (i + 1);

	        str += "<br> <label> " + cname + ": </label> <input type= 'text' name= '" + cname + "'>";
	        str += "&nbsp; &nbsp;";
	        str += "<label> Players: </label> <input type= 'text' name= '" + pname + "' value= '0'>";
	        str += "&nbsp; &nbsp;";
	        str += "<label> Price: </label> <input type= 'text' name= '" + price + "' value= '0'>";
	    }

	    elem.parentNode.removeChild(elem);

	    categories.innerHTML = str;
	    here.appendChild(categories);
	}
	</script>

</head>

<body>
	<form action= "add_sport_trgt.jsp" method= "post">
	<center>
		<label> Sport: </label>
		<input type= "text" name= "sport">

		<br>
		<label> Sub Categories: </label>
		<input type= "text" id= "subs" name= "subs" value= "0"> &nbsp; &nbsp; 
		
		<button type= "button" onclick= "addSubs()"> + </button> 

		<table>
			<tr id= "here">
				<div id= "dummy">
					<br>
					<label>  Players: </label>
					<input type= "text" name= "players">

					<br>
					<label> Price: </label>
					<input type= "text" name= "price" value= "0">
				</div> 
			</tr>
		</table>

		<br>
		<label> Info(any): </label>
		<textarea rows= "5" cols= "32">  </textarea>

		<br>
		<input type= "submit" name= "submit" value= "Proceed">
	</center>
	</form>
</body>

</html>