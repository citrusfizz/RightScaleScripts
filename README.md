### PowerShell Instructions

Set the ability to run scripts

_Set-ExecutionPolicy RemoteSigned_

Run the script! with an account #

_./observeurl.ps1 4454_


### Ruby Instructions

make sure to install the required Ruby Gems as sudo

_sudo -i_

_gem install http https uri launchy_

Make sure to set X with chmod

_chmod +x observeurl.rb_

Then specify your Email and Password in the observeurl.rb file

Use the script with any link or account # 

Example url:

_./observeurl https://us-3.rightscale.com/acct/712/accounts/712_

Example Account #:

_./observeurl 712_

If you are using a URL  it will automatically load in your default browser (make sure you are logged into the master account first!)


