// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(dplyr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var x_df = getValue("bind_x");
    var y_df = getValue("bind_y");
    var operation = getValue("bind_op");
    echo("data.bound <- " + operation + "(" + x_df + ", " + y_df + ")\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Combine by Binding results")).print();

    var save_name = getValue("bind_save.objectname");
    if(getValue("bind_save.active")){
      echo("rk.header(\"Bind result saved as: " + save_name + "\", level=3)\n");
      echo("rk.print(head(data.bound))\n");
    }
  
	//// save result object
	// read in saveobject variables
	var bindSave = getValue("bind_save");
	var bindSaveActive = getValue("bind_save.active");
	var bindSaveParent = getValue("bind_save.parent");
	// assign object to chosen environment
	if(bindSaveActive) {
		echo(".GlobalEnv$" + bindSave + " <- data.bound\n");
	}

}

