// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(dplyr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var x_df = getValue("mjoin_x");
    var y_df = getValue("mjoin_y");
    var op = getValue("mjoin_op");
    var by = getValue("mjoin_by");
    var command = "data.mutated <- " + op + "(" + x_df + ", " + y_df;
    if(by){ command += ", by=" + by; }
    command += ")";
    echo(command + "\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Mutating Joins results")).print();

    var save_name = getValue("mjoin_save.objectname");
    if(getValue("mjoin_save.active")){
      echo("rk.header(\"Join result saved as: " + save_name + "\", level=3)\n");
      echo("rk.print(head(data.mutated))\n");
    }
  
	//// save result object
	// read in saveobject variables
	var mjoinSave = getValue("mjoin_save");
	var mjoinSaveActive = getValue("mjoin_save.active");
	var mjoinSaveParent = getValue("mjoin_save.parent");
	// assign object to chosen environment
	if(mjoinSaveActive) {
		echo(".GlobalEnv$" + mjoinSave + " <- data.mutated\n");
	}

}

