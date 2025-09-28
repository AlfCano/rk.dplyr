// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(dplyr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var x_df = getValue("setop_x");
    var y_df = getValue("setop_y");
    var operation = getValue("setop_op");
    echo("data.set <- " + operation + "(" + x_df + ", " + y_df + ")\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Set Operations results")).print();

    var save_name = getValue("setop_save.objectname");
    if(getValue("setop_save.active")){
      echo("rk.header(\"Set result saved as: " + save_name + "\", level=3)\n");
      echo("rk.print(head(data.set))\n");
    }
  
	//// save result object
	// read in saveobject variables
	var setopSave = getValue("setop_save");
	var setopSaveActive = getValue("setop_save.active");
	var setopSaveParent = getValue("setop_save.parent");
	// assign object to chosen environment
	if(setopSaveActive) {
		echo(".GlobalEnv$" + setopSave + " <- data.set\n");
	}

}

