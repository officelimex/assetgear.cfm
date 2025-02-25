<!DOCTYPE html>
<html>
<head>
<title>AssetGear &mdash; Reset Password</title>
<link rel="icon" href="favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon"> 
<link rel="shortcut icon" href="favicon.ico">
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/img/144_icon.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/img/72_icon.png">
<link rel="apple-touch-icon-precomposed" href="assets/img/57_icon.png">

<style>
html, body{
   height: 100%;
}

body{
	font: 12px 'Lucida Sans Unicode', 'Trebuchet MS', Arial, Helvetica;
	margin: 0;
	background: url(assets/img/bg/speeding.jpg) no-repeat fixed center center; 
	-webkit-background-size:cover;
	-moz-background-size:cover;
	-o-background-size:cover;
	background-size:cover;
	   /*background-color: #d9dee2;	
    background-image: -webkit-gradient(linear, left top, left bottom, from(#ebeef2), to(#d9dee2));
    background-image: -webkit-linear-gradient(top, #ebeef2, #d9dee2);
    background-image: -moz-linear-gradient(top, #ebeef2, #d9dee2);
    background-image: -ms-linear-gradient(top, #ebeef2, #d9dee2);
    background-image: -o-linear-gradient(top, #ebeef2, #d9dee2);
    background-image: linear-gradient(top, #ebeef2, #d9dee2);*/ 
}
/*--------------------*/

#note	{  
	width: 200px;
	height: 240px;
	margin: -150px 0 0 -230px;
	padding: 60px 60px 60px 0px;
	position: absolute;
	top: 40%;
	left: 45%;
	z-index: 0;
}

#footer	{
	bottom:10px;
	position: absolute; 
	color: #efefef; 
	right:50px
}

#forget{
	background-color: #fff; 
	background-image: -webkit-gradient(linear, left top, left bottom, from(#fff), to(#eee));
	background-image: -webkit-linear-gradient(top, #fff, #eee);
	background-image: -moz-linear-gradient(top, #fff, #eee);
	background-image: -ms-linear-gradient(top, #fff, #eee);
	background-image: -o-linear-gradient(top, #fff, #eee);
	background-image: linear-gradient(top, #fff, #eee);
	height: 240px;
	width: 330px;
	margin: -150px 0 0 -230px;
	padding: 40px;
	position: absolute;
	top: 40%;
	left: 70%;
	z-index: 1;
	border-radius: 3px;
	box-shadow:0 0 2px rgba(0, 0, 0, 0.2),0 1px 1px rgba(0, 0, 0, .2);
	opacity:.9;
}
#forget:before{
    content: '';
    position: absolute;
    z-index: -1;
    /*border: 1px dashed #ccc;*/
    top: 5px;
    bottom: 5px;
    left: 5px;
    right: 5px;
    box-shadow: 0 0 0 1px #fff;
}
/*--------------------*/
#forget h1{
	text-shadow: 1px 1px 2px rgba(255, 255, 255, .7), 0px 2px 1px rgba(0, 0, 0, .5);
	text-align: center;
	color: #666;
	margin: 0 0 30px 0;
	letter-spacing: 1px;
	font: normal 24px/1 Georgia, "Times New Roman", Times, serif;
	position: relative;
}
#forget h1:after, #forget h1:before
{
    background-color: #777;
    content: "";
    height: 1px;
    position: absolute;
    top: 15px;
    width: 30px;   
}
#forget h1:after
{ 
    background-image: -webkit-gradient(linear, left top, right top, from(#777), to(#fff));
    background-image: -webkit-linear-gradient(left, #777, #fff);
    background-image: -moz-linear-gradient(left, #777, #fff);
    background-image: -ms-linear-gradient(left, #777, #fff);
    background-image: -o-linear-gradient(left, #777, #fff);
    background-image: linear-gradient(left, #777, #fff);      
    right: 0;
}
#forget h1:before{
    background-image: -webkit-gradient(linear, right top, left top, from(#777), to(#fff));
    background-image: -webkit-linear-gradient(right, #777, #fff);
    background-image: -moz-linear-gradient(right, #777, #fff);
    background-image: -ms-linear-gradient(right, #777, #fff);
    background-image: -o-linear-gradient(right, #777, #fff);
    background-image: linear-gradient(right, #777, #fff);
    left: 0;
}
/*--------------------*/
fieldset{
    border: 0;
    padding: 0;
    margin: 0;
}
/*--------------------*/

#inputs input{
	background: #f1f1f1 url(assets/img/login-sprite.png) no-repeat;
	padding: 15px 15px 15px 40px;
	margin: 0 0 10px 0;
	width: 270px; /* 353 + 2 + 45 = 400 */
	border: 1px solid #ccc;
	border-radius: 5px;
	box-shadow: 0 1px 1px #ccc inset, 0 1px 0 #fff;
	letter-spacing: 1px;
	font-size: 14px;
}
#username{
    background-position: 15px -2px !important;
}
#password {
    background-position: 15px -52px !important;
	color:red;
}
#inputs input:focus{
    background-color: #fff;
    border-color: #e8c291;
    outline: none;
    box-shadow: 0 0 0 1px #e8c291 inset;
}
/*--------------------*/

#actions{
    margin: 25px 0 0 0;
}
#submit{		
    background-color: #ffb94b;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#fddb6f), to(#ffb94b));
    background-image: -webkit-linear-gradient(top, #fddb6f, #ffb94b);
    background-image: -moz-linear-gradient(top, #fddb6f, #ffb94b);
    background-image: -ms-linear-gradient(top, #fddb6f, #ffb94b);
    background-image: -o-linear-gradient(top, #fddb6f, #ffb94b);
    background-image: linear-gradient(top, #fddb6f, #ffb94b);
    border-radius: 3px;
    text-shadow: 0 1px 0 rgba(255,255,255,0.5);
    box-shadow: 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 0 rgba(255, 255, 255, 0.3) inset;    
    border-width: 1px;
    border-style: solid;
    border-color: #d69e31 #e3a037 #d5982d #e3a037;
    float: right;
    height: 35px;
    padding: 0;
    width: 120px;
    cursor: pointer;
    font: bold 15px Arial, Helvetica;
    color: #8f5a0a;
}
#submit:hover,#submit:focus{		
    background-color: #fddb6f;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#ffb94b), to(#fddb6f));
    background-image: -webkit-linear-gradient(top, #ffb94b, #fddb6f);
    background-image: -moz-linear-gradient(top, #ffb94b, #fddb6f);
    background-image: -ms-linear-gradient(top, #ffb94b, #fddb6f);
    background-image: -o-linear-gradient(top, #ffb94b, #fddb6f);
    background-image: linear-gradient(top, #ffb94b, #fddb6f);
}	
#submit:active{		
    outline: none;
     box-shadow: 0 1px 4px rgba(0, 0, 0, 0.5) inset;		
}
#submit::-moz-focus-inner{
  border: none;}

#actions a{
    color: #3151A2;    
    float: left;
    line-height: 35px;
    margin-left: 10px;
}

/*--------------------*/
#back{
    display: block;
    text-align: center;
    position: relative;
    top: 60px;
    color: #999;
}
</style>

</head><body>
<div id="note">
	<h1 align="center">AssetGear</h1>
    <div style="font-size:15px">Asset Management System</div>
</div>
<cfoutput>
<form action="" method="post" id="forget">
	
    <h1>Retreive Password</h1>

    <fieldset id="inputs">
		<!--- process login code here --->
        <cfif StructKeyExists(form,'un_')> 
            <cfset u = createobject("component","assetgear.com.awaf.User").init()/> 
            <cfset em_ = ""/>
            <cfif !Find('@',form.un_)>
            	<cfset em_ = "@#application.domain#"/>
            </cfif>
            <cfset form.username = form.un_ & em_/> 
            <cfset msg = u.ResetPassword(form.username)/>
        
             
                <div align="center" style="color:orange">#msg#</div>
 
        	
        	
		</cfif><br/><br/>
        <input id="username" name="un_"  type="text" placeholder="Username" autofocus required> 
        <!---<input id="password" name="pwd_" type="password" placeholder="Password" required>	---><div style="height:26px">&nbsp;</div>	
    </fieldset>
    <fieldset id="actions"><a href="login.cfm">Login</a><input type="submit" id="submit" value="Send"></fieldset> 

</form>
</cfoutput> 
<div id="footer">&copy; Copyright <!---<img src="assets/img/cl-16.gif" align="absmiddle"/>---> Officelime Software Limited</div>
</body>

</html>

