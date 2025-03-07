const Confirmation = (title,description,salary,location) => {
	return `<!DOCTYPE html>
	<html>
	
	<head>
		<meta charset="UTF-8">
		<title>Confirmation Email</title>
		<style>
			body {
				background-color: #ffffff;
				font-family: Arial, sans-serif;
				font-size: 16px;
				line-height: 1.4;
				color: #333333;
				margin: 0;
				padding: 0;
			}
	
			.container {
				max-width: 600px;
				margin: 0 auto;
				padding: 20px;
				
			}
	
			.logo {
				max-width: 200px;
				margin-bottom: 20px;
			}
	
			.message {
				font-size: 18px;
				font-weight: bold;
				margin-bottom: 20px;
				text-align: center;
			}
	
			.body {
				font-size: 16px;
				margin-bottom: 20px;
			}
	
			.cta {
				display: inline-block;
				padding: 10px 20px;
				background-color: #FFD60A;
				color: #000000;
				text-decoration: none;
				border-radius: 5px;
				font-size: 16px;
				font-weight: bold;
				margin-top: 20px;
			}
	
			.support {
				font-size: 14px;
				color: #999999;
				margin-top: 20px;
			}
	
			.highlight {
				font-weight: bold;
				text-align: center;
			}
		</style>
	
	</head>
	
	<body>
		<div class="container">
        <a href="https://imgbb.com/"><img src="https://i.ibb.co/xqryQ6sK/logo.png" alt="logo" border="0"></a>
			<div class="message">Confirmation Email</div>
			<div class="body">
				<p>Dear User,</p>
				<p>Thank you for registering with CropGaurdAI.</p>
				<h2 class="highlight">${title}</h2>
				<p><h3>Desciption:</h3> ${description}</p>
				<br>
				<p>Location: ${location}</p>
				<p>Salary: ₹${salary}</p>
			</div>
			<div class="support">If you have any questions or need assistance, please feel free to reach out to us at <a
					href="mailto:info@cropguardai.com">info@cropguardai.com</a>. We are here to help!</div>
		</div>
	</body>
	
	</html>`;
};
module.exports = Confirmation;