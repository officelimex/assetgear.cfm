component output="true"  {

	this.name	 			= ''
	this.datasource = ''

	public boolean function onApplicationStart() {

		application.site.url = "http://localhost/"

		return true;
	}

}