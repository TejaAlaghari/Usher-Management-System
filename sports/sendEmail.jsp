<%@ page import = "java.io.*, java.util.*, javax.mail.*"%>
<%@ page import = "javax.mail.internet.*, javax.activation.*"%>
<%@ page import = "javax.servlet.http.*, javax.servlet.*" %>

<%
	final String username = "alagharimahateja1998@gmail.com";
	final String password = "TiMnPf(g)";

	Properties props = new Properties();
	props.put("mail.smtp.auth", "true");
	props.put("mail.smtp.starttls.enable", "true");
	props.put("mail.smtp.host", "smtp.gmail.com");
	props.put("mail.smtp.port", "587");

	Session mailSession = Session.getInstance(props,
		new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
	});

	Message message = new MimeMessage(mailSession);
	
	message.setFrom(new InternetAddress("alagharimahateja1998@gmail.com"));
	message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("alagharimahateja1998@gmail.com"));
	
	message.setSubject("Testing Subject");
	message.setText("Dear Mail Crawler," + "\n\n No spam to my email, please!");

	Transport.send(message);

	System.out.println("Done");

%>