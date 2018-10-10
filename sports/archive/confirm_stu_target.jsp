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
		int i = 0, count = 0, req_count = 0;
		

		String view = request.getParameter("view");
		String clg = request.getParameter("clg");
		String gam = request.getParameter("gam1");
		String cat = request.getParameter("cat1");

		String msg = "Select A Game";
		String gname = gam;
			
		if(cat != null && !cat.equals("None"))
			gname += "_" + cat;

		String query = "";

		try
		{
			Class.forName("com.mysql.jdbc.Driver"); 
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sports","testUser","testPswd");

			if(gam != null)
			{
				query = "SELECT players FROM categories WHERE sport = '" + gam + "'";

				if(cat != null)
					query += " and category = '" + cat + "'";

				stmt = con.createStatement();
				rs = stmt.executeQuery(query);

				if(rs.next())
					req_count = Integer.parseInt(rs.getString(1));
			}

			stmt = con.createStatement();
			rs = stmt.executeQuery("SELECT COUNT(*) FROM " + gname + " g, logins l WHERE g.user_name = l.user_name and  l.college = '" + clg + "'");

			if(rs.next())
				count = Integer.parseInt(rs.getString(1));
		}
		catch(Exception e)
		{
			//msg = "Select Category For The Game, " + gam;
			//response.sendRedirect("default.html");
		}
	%>

	<script type = "text/javascript">

		var count = Number("<%= count %>");
		var view = Number("<%= view%>");
		var player = new Array();
		var req_count = 0;

		for(var ind = 0; ind < count; ind++)
			player[ind] = new Array();

	</script>

	<%
		try
		{
			stmt = con.createStatement();
			rs = stmt.executeQuery("SELECT g.user_name, m.first_name, m.last_name, g.selected FROM " + gname + " g, members m WHERE g.user_name = m.user_name");

			out.println("<script type = 'text/javascript'>");

				while(rs.next())
				{
					out.println("player[" + i + "][0] = '" + rs.getString(1) + "'");
					out.println("player[" + i + "][1] = '" + rs.getString(2) + "'");
					out.println("player[" + i + "][2] = '" + rs.getString(3) + "'");
					out.println("player[" + i + "][3] = '" + rs.getString(4) + "'");

					i++;
				}

			out.println("</script>");
		}
		catch(Exception e)
		{
			//response.sendRedirect("default.html");
		}
	%>

	<script type= "text/javascript">
	
		function fill_table()
		{
			var tr, td, here, playerUname, playerName, radioButton, playerStatus;
			var i = 1;

			req_count = Number("<%= req_count%>");

			if((view == 0 && count < req_count) || count == 0)
				return;
			
			here = document.getElementById("here");

			// Removing Default Stmt
			var element = document.getElementById("tr1");
			element.parentNode.removeChild(element);

			// Creating A New Row
			tr = document.createElement("TR");
			here.appendChild(tr);

			// Creating Player User Name Column
			td = document.createElement("TH");
			td.appendChild(document.createTextNode("User Name"));
			tr.appendChild(td);

			// Creating Player Name Column
			td = document.createElement("TH");
			td.appendChild(document.createTextNode("Player"));
			tr.appendChild(td);

			// Creating Selection Options And Status Info Column Names 
			if(view == 0)
			{
				// Creating Selected Column
				td = document.createElement("TH");
				td.appendChild(document.createTextNode("Select"));
				tr.appendChild(td);

				// Creating Rejected Column
				td = document.createElement("TH");
				td.appendChild(document.createTextNode("Reject"));
				tr.appendChild(td);
			}
			else
			{
				// Creating Player Status Column
				td = document.createElement("TH");
				td.appendChild(document.createTextNode("Status"));
				tr.appendChild(td);
			}

			for(var ind = 0; ind < count; ind++)
			{
				// Creating A New Row With An ID
				tr = document.createElement("TR");
				tr.setAttribute("id", "tr" + (ind + 1));
			
				// Creating A New Column With An ID For Player Uname
				td = document.createElement("TD");
				td.setAttribute("id", "td" + (ind + 1) + "_" + i++);
				td.setAttribute("align", "center");
				tr.appendChild(td);

				// Creating A ReadOnly Text Element For Player Uname
				playerUname = document.createElement("input");
				playerUname.setAttribute("type", "text");
				playerUname.setAttribute("name", "Uname" + (ind + 1));
				playerUname.setAttribute("value", player[ind][0]);
				playerUname.setAttribute("style", "text-align: center;");
				playerUname.readOnly = true;
				td.appendChild(playerUname);

				// Creating A New Column With An ID For Player Name
				td = document.createElement("TD");
				td.setAttribute("id", "td" + (ind + 1) + "_" + i++);
				td.setAttribute("align", "center");
				tr.appendChild(td);

				// Creating A ReadOnly Text Element For Player Name
				playerName = document.createElement("input");
				playerName.setAttribute("type", "text");
				playerName.setAttribute("name", "Player" + (ind + 1));
				playerName.setAttribute("value", player[ind][1] + " " + player[ind][2]);
				playerName.setAttribute("disabled", "disabled");
				playerName.setAttribute("style", "text-align: center;");
				playerName.readOnly = true;
				td.appendChild(playerName);

				if(view == 0)
				{
					// Creating A New Column With An ID For Selection Option
					td = document.createElement("TD");
					td.setAttribute("id", "td" + (ind + 1) + "_" + i++);
					td.setAttribute("align", "center");
					tr.appendChild(td);

					// Creating A radioButton Element For Selected
					radioButton = document.createElement("input");
					radioButton.setAttribute("type", "radio");
					radioButton.setAttribute("name", "status" + (ind + 1));
					radioButton.setAttribute("id", "status" + (ind + 1));
					radioButton.setAttribute("value", "select");
					radioButton.appendChild(document.createTextNode("Select"));
					if(player[ind][3] === "1")
						radioButton.checked = true;
					td.appendChild(radioButton);

					// Creating A New Column With An ID For Rejection Option
					td = document.createElement("TD");
					td.setAttribute("id", "td" + (ind + 1) + "_" + i++);
					td.setAttribute("align", "center");
					tr.appendChild(td);

					// Creating A radioButton Element For Rejected
					radioButton = document.createElement("input");
					radioButton.setAttribute("type", "radio");
					radioButton.setAttribute("name", "status" + (ind + 1));
					radioButton.setAttribute("id", "status" + (ind + 1));
					radioButton.setAttribute("value", "reject");
					radioButton.appendChild(document.createTextNode("Reject"));
					if(player[ind][3] === "0")
						radioButton.checked = true;
					td.appendChild(radioButton);
				}
				else
				{
					// Creating A New Column With An ID For Player Status
					td = document.createElement("TD");
					td.setAttribute("id", "td" + (ind + 1) + "_" + i++);
					td.setAttribute("align", "center");
					tr.appendChild(td);

					/* Creating A Text Node For Player Name
					if(player[ind][2] === "0")
						playerStatus = document.createTextNode("Rejected");
					else
						playerStatus = document.createTextNode("Selected");
					*/

					// Creating A ReadOnly Text Element For Player Name
					playerStatus = document.createElement("input");
					playerStatus.setAttribute("type", "text");
					playerStatus.setAttribute("name", "Player" + (ind + 1));
					if(player[ind][3] === "0")
						playerStatus.setAttribute("value", "Rejected");
					else
						playerStatus.setAttribute("value", "Selected");
					playerStatus.setAttribute("style", "text-align: center;");
					playerStatus.readOnly = true;
					td.appendChild(playerStatus);
				}

				// Appending The Row To Table
				here.appendChild(tr);
 		
			}

			if(view == 0)
			{
				// Creating A New Row With An ID
				tr = document.createElement("TR");
				tr.setAttribute("id", "tr" + (ind + 1));
			
				// Creating A New Column With An ID For Submit
				td = document.createElement("TD");
				td.setAttribute("id", "td" + (ind + 1) + "_" + i++);
				td.setAttribute("colspan", "3");
				td.setAttribute("align", "center");
				tr.appendChild(td);

				// Creating A Submit Button
				submit = document.createElement("input");
				submit.setAttribute("type", "submit");
				submit.setAttribute("value", "submit");
				td.appendChild(submit);

				here.appendChild(tr);
			}

		}

		function validate()
		{
			var scount = 0;
			var radios;

			for(var ind = 0; ind < count; ind++)
			{
				radios = document.getElementsByName("status" + (ind + 1));

				for(var i = 0; i < radios.length; i++)
					if(radios[i].checked && radios[i].value === "select")
						scount++;
			}

			alert("seleted: " + scount);

			if(scount == req_count)
				return(true);
			else
			{
				if(req_count < scount)
					alert("You've seleted " + (scount - req_count) + " extra players (Req: " + req_count + ")");
				else
					alert("You've seleted " + (req_count - scount) + " fewer players (Req: " + req_count + ")");

				return(false);
			}
		}

	</script>

</head>

<body>

	<center>

	<%
		if(view != null && view.equals("0"))
		{
			out.println("<form action= 'commit_confirmation.jsp' method= 'post' target= '_blank' onsubmit= 'return validate()'>");
		}
	%>

	<table align= "center" id= "here" width= "50%" style= "border-collapse: collapse;">

		<tr id= "tr1"> 
			<td id= "td1_1" align= "center"> 
				<% 
					if(gam == null || gam.equals("None"))
						out.println("Select A Game");
					else
					{
						// out.println("<br> " + gam + " - " + req_count + " - " + count);

						if(req_count > 0)
						{
							if(count < req_count && view.equals("0"))
								out.println("No Sufficient Players");
							if(count == 0 && view.equals("1"))
								out.println("No Registered Players");
						}
						else
							out.println("Select A Valid Game");
					}
				%>

	</table>

	<script type = "text/javascript">

		fill_table();

	</script>

	<%
		if(view != null && view.equals("0"))
		{
			out.println("<input type= 'hidden' name= 'game' value= '" + gname + "'> </form>");
		}
	%>

	</center>

</body>

</html>