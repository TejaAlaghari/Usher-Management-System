<!DOCTYPE html>
<%@ page import = "java.sql.*" %> 
<%@ page import = "java.io.*" %> 

<html>

<head>

	<title> Student Confirmation </title>

	<%
		Connection con = null;  
		Statement stmt = null;
		ResultSet rs = null;
		ResultSetMetaData md = null;
		PreparedStatement prepStmt = null;
		int i = 0, count = 0;

		Class.forName("com.mysql.jdbc.Driver"); 
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sports","testUser","testPswd");

		stmt = con.createStatement();
		rs = stmt.executeQuery("SELECT COUNT(*) FROM categories");

		if(rs.next())
			count = Integer.parseInt(rs.getString(1));
	%>

	<script type = "text/javascript">

		var games = new Array();
		var gcount = Number("<%= count %>");

		for(var ind = 0; ind <= gcount + 1; ind++)
			games[ind] = new Array();

	</script>

	<%
		stmt = con.createStatement();
		rs = stmt.executeQuery("SELECT sport, category FROM categories ORDER BY sport, category");

		out.println("<script type = 'text/javascript'>");

		out.println("games[" + i + "][0] = 'None'");
		out.println("games[" + i + "][1] = 'None'");
		out.println("games[" + i + "][2] = '1'");

		i++;

		while(rs.next())
		{
			out.println("games[" + i + "][0] = '" + rs.getString(1) + "'");
			out.println("games[" + i + "][1] = '" + rs.getString(2) + "'");
			out.println("games[" + i + "][2] = '1'");

			i++;
		}

		out.println("</script>");
	%>

	<script type="text/javascript">
		
		function create_select(game, ind)
		{
			var select;
			var option;
			var dummy;
			var element_td;

			select = document.createElement("SELECT");
			element_td = document.createElement("TD");

		    select.setAttribute("id", game);
		    select.setAttribute("name", game);

		    if(ind == 1)
		    {
		    	select.setAttribute("onchange", "change_gam(this)");

		    	element_td.setAttribute("id", "gtd1" + "_" + 1);
		    }
		    else
		    	element_td.setAttribute("id", "gtd1" + "_" + 2);

		    document.getElementById("gtr1").appendChild(element_td);

		    element_td.appendChild(select);


		    // Adding Default Option 
		    option = document.createElement("option");
					    
			option.setAttribute("value", "None");
			var name = document.createTextNode("None");
					    
			option.appendChild(name);

			document.getElementById(game).appendChild(option);

			game.selectedIndex = 0;

		    if(ind == 2)
		    	return;

		    //Add remaining options for game
		    for(var i = 1; i <= gcount; i++) 
		    {
		    	if(games[i][2] === "1")
				{
				    option = document.createElement("option");
					    
				    option.setAttribute("value", games[i][0]);
				    name = document.createTextNode(games[i][0]);
					    
				    option.appendChild(name);

				    document.getElementById(game).appendChild(option);
			    }
			}
		}

		function change_gam(ele) 
		{
			//alert(ele.value);
			var Target = document.getElementById("cat" + ele.id.substring(3));

			var index = 1;

			var tvalue = Target.value;

			// Adding New Options 
			while(Target.options.length != 1)
				Target.remove(index);

			//alert(ele.value);

			for(var i = 1; i <= gcount; i++) 
		    {
		    	if(games[i][0] === ele.value && games[i][2] === "1" && games[i][1] !== "None")
				{
				    option = document.createElement("option");
					    
				    option.setAttribute("value", games[i][1]);
				    var name = document.createTextNode(games[i][1]);
					    
				    option.appendChild(name);

				    Target.appendChild(option);
				}
			}

		}

		function show_unique(ele)
		{
			var Target = document.forms[0][ele];
			var option = "";

			for(var i = 0; i < Target.options.length; i++)
			{
				option = Target.options[i].value;

				for(var j = i + 1; j < Target.options.length; j++)
				{
					if(Target.options[j].value === option)
						Target.remove(j--);
				}
			}
		}

	</script>

</head>

<body>
	
	<center>

	<form action= "confirm_stu_target.jsp" method= "post" target= "trgt" accept-charset= "utf-8">
		
		<table align= "center">

			<tr id= "gtr1">

			<script type= "text/javascript">
				
				create_select("gam1", 1);
				create_select("cat1", 2);

				show_unique("gam1");
				show_unique("cat1");

			</script>

				<td id= "td1_3"> <input type= "submit" name="submit" value= "submit">
			
		</table>

		<% out.println("<input type= 'hidden' name= 'clg'  value= '" + request.getParameter("clg") + "'>"); %>
		<% out.println("<input type= 'hidden' name= 'view' value= '" + request.getParameter("view") + "'>"); %>

	</form>

	</center>
</body>

</html>