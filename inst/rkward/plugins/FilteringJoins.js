// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(dplyr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var x_df = getValue("fjoin_x");
    var y_df = getValue("fjoin_y");
    var op = getValue("fjoin_op");
    var by = getValue("fjoin_by");
    var command = "data.filtered <- " + op + "(" + x_df + ", " + y_df;
    if(by){ command += ", by=" + by; }
    command += ")";
    echo(command + "\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Filtering Joins results")).print();

    var save_name = getValue("fjoin_save.objectname");
    if(getValue("fjoin_save.active")){
      echo("rk.header(\"Filter result saved as: " + save_name + "\", level=3)\n");
      echo("rk.print(head(data.filtered))\n");
    }
  
	//// save result object
	// read in saveobject variables
	var fjoinSave = getValue("fjoin_save");
	var fjoinSaveActive = getValue("fjoin_save.active");
	var fjoinSaveParent = getValue("fjoin_save.parent");
	// assign object to chosen environment
	if(fjoinSaveActive) {
		echo(".GlobalEnv$" + fjoinSave + " <- data.filtered\n");
	}

}

