<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AssetGear &mdash; Login</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/img/144_icon.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/img/72_icon.png">
    <link rel="apple-touch-icon-precomposed" href="assets/img/57_icon.png">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        <cfoutput>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url(assets/img/bg/eng#randrange(1,4)#.jpg) no-repeat fixed center center;
            background-size: cover;
            height: 100vh;
            display: flex;
            align-items: center;
        }
        </cfoutput>
        
        .login-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        
        .login-form-container {
            padding: 2rem;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .login-header h1 {
            color: #333;
            font-weight: 600;
        }
        
        .form-control {
            padding: 0.8rem 1rem 0.8rem 2.5rem;
            border-radius: 5px;
            margin-bottom: 1rem;
            border: 1px solid #ddd;
        }
        
        .input-icon {
            position: absolute;
            left: 1rem;
            top: 0.8rem;
            color: #aaa;
        }
        
        .form-floating {
            position: relative;
        }
        
        .btn-login {
            background: linear-gradient(to right, #fddb6f, #ffb94b);
            border: none;
            color: #8f5a0a;
            font-weight: bold;
            padding: 0.8rem;
            border-radius: 5px;
            width: 100%;
            margin-top: 1rem;
        }
        
        .btn-login:hover {
            background: linear-gradient(to right, #ffb94b, #fddb6f);
        }
        
        /* Video container styling with border radius */
        .ratio {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .footer {
            position: fixed;
            bottom: 10px;
            right: 20px;
            color: #fff;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }
        
        @media (max-width: 991.98px) {
            .order-md-1 {
                order: 1;
            }
            .order-md-2 {
                order: 2;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="row login-container">
                    <!-- Login Form Section -->
                    <div class="col-lg-6 login-form-container order-md-2">
                        <div class="login-header">
                            <img src="assets/img/client_logo.png" width="80" class="mb-2">
                            <img src="icon.png" width="60" class="mb-2">
                            <h1>AssetGear</h1>
                            <p class="text-muted">Asset Management System</p>
                        </div>
                        
                        <cfoutput>
                        <form action="" method="post">
                            <!--- process login code here --->
                            <cfif StructKeyExists(form,'un_')>
                                <cfset s = createobject("component","assetgear.com.awaf.Security").init(false,false)/>
                                <cfset l = createobject("component","assetgear.com.awaf.Login").init()/>
                                <cfset em_ = ""/>
                                <cfif !Find('@',form.un_)>
                                    <cfset em_ = "@#application.domain#"/>
                                </cfif>
                                <cfset form.username = trim(lcase(form.un_ & em_))/>
                                <cfset form.password = form.pwd_/>
                                <cfset l.SignIn(form,s)/>

                                <cfif Not l.IsLogin>
                                    <div class="alert alert-danger text-center">#l.errmsg#</div>
                                <cfelse>
                                    <!--- set session --->
                                    <cflock type="exclusive" scope="session" timeout="30">
                                        <cfset session.IsLogin = true />
                                        <cfset session.userInfo = l.userInfo />
                                        <cfset session.delegate = l.delegate />
                                    </cflock>
                                    <cflocation url="index.cfm" addtoken="no">
                                </cfif>
                            </cfif>
                            
                            <div class="form-floating mb-3">
                                <div class="position-relative">
                                    <i class="fas fa-user input-icon"></i>
                                    <input type="text" class="form-control" id="username" name="un_" placeholder="Username" required autofocus>
                                </div>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <div class="position-relative">
                                    <i class="fas fa-lock input-icon"></i>
                                    <input type="password" class="form-control" id="password" name="pwd_" placeholder="Password" required>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <a href="forget.cfm" class="text-decoration-none">Forgot your password?</a>
                            </div>
                            
                            <button type="submit" class="btn btn-login">Log in</button>
                            
                            <div class="text-center mt-4">
                                <p>Don't have an account? <a href="register.cfm" class="text-decoration-none">Register</a></p>
                            </div>
                        </form>
                        </cfoutput>
                    </div>
                    
                    <!-- Video Section -->
                    <div class="col-lg-6 d-flex align-items-center justify-content-center p-4 order-md-1" >
                        <div class="w-100">
                            <div class="ratio ratio-16x9">
                                <iframe src="https://www.youtube.com/embed/videoseries?list=PLLZCrDdwKeBoi2ZbLokl7e4p9lQgwOa8D" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="footer">
        &copy; Copyright 2025 Officelime Software Ltd
    </div>
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>