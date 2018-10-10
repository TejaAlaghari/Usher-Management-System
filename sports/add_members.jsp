<!DOCTYPE html>
<%@ page import = "java.sql.*" %> 
<%@ page import = "java.io.*" %> 
<%@ page import = "java.util.*" %>

<html>

<head>
	<title> Adding Members </title>
</head>

<body>

	<center>

	<%

		Connection con = null;  
		Statement stmt = null;
		PreparedStatement prepStmt = null;
		ResultSet rs = null;
		int res = 0;

		String uname = request.getParameter("uname");
		String pswd = request.getParameter("pswd");
		String fname = request.getParameter("fname");
		String lname = request.getParameter("lname");
		String email = request.getParameter("email");
		String phno = request.getParameter("phno");
		String bday = request.getParameter("bday");
		String clg = request.getParameter("clg");

		Class.forName("com.mysql.jdbc.Driver"); 
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sports","testUser","testPswd");

		stmt = con.createStatement();
		stmt.executeUpdate("CREATE TABLE IF NOT EXISTS logins " + 
			"(" + 
			"user_name varchar(15) NOT NULL PRIMARY KEY, " + 
			"password varchar(15) NOT NULL, " +
			"college varchar(25) NOT NULL, " + 
			"special int(2) DEFAULT 0 " + 
			")");

		try
		{
			res = stmt.executeUpdate("INSERT INTO logins (user_name, password, college) VALUES " + 
			"(" + 
			"'" + uname + "', " + 
			"'" + pswd  + "', " + 
			"'" + clg + "' " + 
			")");

			out.println("<br> Player Authenticated !");
		}
		catch(Exception e)
		{
			out.println("<br> Error: Logging in ! <br> " + e);
		}


		stmt = con.createStatement();
		stmt.executeUpdate("CREATE TABLE IF NOT EXISTS members " + 
			"(" + 
			"user_name varchar(15) NOT NULL PRIMARY KEY, " +
			"first_name varchar(15) NOT NULL, " + 
			"last_name varchar(15) NOT NULL, " + 
			"e_mail varchar(30) NOT NULL UNIQUE, " + 
			"phone_num varchar(11) NOT NULL UNIQUE, " + 
			"bitrh_day DATE NOT NULL, " +
			"FOREIGN KEY (user_name) REFERENCES logins(user_name) ON DELETE CASCADE " + 
			")");

		try
		{
			res = stmt.executeUpdate("INSERT INTO members VALUES " + 
			"(" + 
			"'" + uname + "', " + 
			"'" + fname + "', " + 
			"'" + lname + "', " + 
			"'" + email + "', " + 
			"'" + phno  + "', " + 
			"'" + bday  + "'" +
			")");

			out.println("<br> Player " + lname + " is added to Members!");

			String[] games =  new String[5];
			int i = 0;

			Enumeration parameterList = request.getParameterNames();

			while(parameterList.hasMoreElements())
			{
			    String sName = parameterList.nextElement().toString();
			    
			    if(sName.startsWith("gam"))
			    {
			    	games[i++] = sName;
			    }
			}

			int ind = -1;

			while(++ind < games.length && games[ind] != null)
			{
				res = 0;
				String gname, gam, cat;

				gam = request.getParameter(games[ind]);
				cat = request.getParameter("cat" + games[ind].substring(3));

				gname = gam;
				if(!cat.equals("None"))
					gname += "_" + cat;

				
				stmt = con.createStatement();
				stmt.executeUpdate("CREATE TABLE IF NOT EXISTS " + gname + " " + 
				"(" + 
				"user_name varchar(15) NOT NULL, " +
				"selected int(2) DEFAULT 0, " +
				"FOREIGN KEY (user_name) REFERENCES members(user_name) ON DELETE CASCADE " +
				")");

				try
				{
					res = stmt.executeUpdate("INSERT INTO " + gname + " (user_name) VALUES " + 
					"(" + 
					"'" + uname + "'" + 
					")");

					out.println("<br> And got registered for " + gam);
					if(!cat.equals("None"))
						out.println(" under " + cat + " category !");
				}
				catch(Exception e)
				{
					out.println("<br> Error: Registration of Player " + lname + " for " + gname + " ! <br> " + e);
				}


				stmt = con.createStatement();
				stmt.executeUpdate("CREATE TABLE IF NOT EXISTS player " + 
				"(" + 
				"user_name varchar(15) NOT NULL, " +
				"game varchar(15) NOT NULL, " +
				"category varchar(15) NOT NULL, " +
				"team varchar(15) DEFAULT 'none', " +
				"admin int(2) DEFAULT 0, " + 
				"payment int(2) DEFAULT 0, " + 
				"FOREIGN KEY (user_name) REFERENCES members(user_name) ON DELETE CASCADE " +
				")");

				try
				{
					res = stmt.executeUpdate("INSERT INTO player (user_name, game, category) VALUES " + 
					"(" + 
					"'" + uname + "', " + 
					"'" + gam + "', " + 
					"'" + cat + "'" + 
					")");
				}
				catch(Exception e)
				{
					out.println("<br> Error: Player already registered for " + gname);
				}

			}
		}
		catch(Exception e)
		{
			out.println("<br> Error: Registration of Player " +fname + " into players ! <br> " + e);
		}
		
	%>
	
	<br> <br> 
	<br> <a href= "index.html"> Home </a>
	</center>
</body>

</html>