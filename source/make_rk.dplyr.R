# make_dplyr_plugin.R
# This script programmatically generates an RKWard plugin for dplyr table combinations.
# To run: source("make_dplyr_plugin.R")

local({

  # =========================================================================================
  # Package Definition and Metadata
  # =========================================================================================
  library(rkwarddev)
  rkwarddev.required("0.08-1")

  package_about <- rk.XML.about(
    name = "rk.dplyr",
    author = person(
      given = "Alfonso",
      family = "Cano",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "An RKWard plugin for data table combination and manipulation using the 'dplyr' library.",
      version = "0.1.3", # Version incremented for UI label improvement
      url = "https://github.com/AlfCano/rk.dplyr",
      license = "GPL (>= 3)"
    )
  )

  dependencies.info <- rk.XML.dependencies(
    dependencies = list(
      rkward.min = "0.7.0",
      R.min = "3.5.0",
      package = list(name = "dplyr", min = "1.0.0", repository = "CRAN")
    )
  )

  # =========================================================================================
  # Main Plugin: Bind Rows/Columns
  # =========================================================================================
  help_main <- rk.rkh.doc(
    title = rk.rkh.title(text = "Combine by Binding (dplyr)"),
    summary = rk.rkh.summary(text = "Binds two data.frames together either by rows (stacking) or by columns (side-by-side).")
  )

  # --- UI Definition (Bind) - Added labels to varselectors ---
  bind_selector_x <- rk.XML.varselector(label="Select data.frame x", id.name="bind_selector_x")
  bind_slot_x <- rk.XML.varslot("First data.frame (x)", source="bind_selector_x", required=TRUE, id.name="bind_x")
  bind_selector_y <- rk.XML.varselector(label="Select data.frame y", id.name="bind_selector_y")
  bind_slot_y <- rk.XML.varslot("Second data.frame (y)", source="bind_selector_y", required=TRUE, id.name="bind_y")

  bind_op_dropdown <- rk.XML.dropdown(label = "Operation", options = list(
    "Bind rows (stack)" = list(val = "bind_rows", chk = TRUE),
    "Bind columns (side-by-side)" = list(val = "bind_cols")
  ), id.name = "bind_op")
  bind_save_obj <- rk.XML.saveobj("Save result as", initial="data.bound", chk=TRUE, id.name="bind_save")

  col_selectors_bind <- rk.XML.col(bind_selector_x, bind_selector_y)
  col_slots_bind <- rk.XML.col(bind_slot_x, bind_slot_y)
  col_options_bind <- rk.XML.col(
    rk.XML.frame(bind_op_dropdown, label="Binding Options"),
    bind_save_obj
  )

  main_dialog <- rk.XML.dialog(
    label="Combine by Binding (dplyr)",
    child=rk.XML.row(col_selectors_bind, col_slots_bind, col_options_bind)
  )

  # --- JS Logic (Bind) ---
  js_calc_main <- '
    var x_df = getValue("bind_x");
    var y_df = getValue("bind_y");
    var operation = getValue("bind_op");
    echo("data.bound <- " + operation + "(" + x_df + ", " + y_df + ")\\n");
  '
  js_print_main <- '
    var save_name = getValue("bind_save.objectname");
    if(getValue("bind_save.active")){
      echo("rk.header(\\"Bind result saved as: " + save_name + "\\", level=3)\\n");
      echo("rk.print(head(data.bound))\\n");
    }
  '

  # =========================================================================================
  # Component 2: Mutating Joins
  # =========================================================================================
  # --- UI Definition (Mutating Joins) - Added labels to varselectors ---
  mjoin_selector_x <- rk.XML.varselector(label="Select data.frame x", id.name="mjoin_selector_x")
  mjoin_slot_x <- rk.XML.varslot("First data.frame (x)", source="mjoin_selector_x", required=TRUE, id.name="mjoin_x")
  mjoin_selector_y <- rk.XML.varselector(label="Select data.frame y", id.name="mjoin_selector_y")
  mjoin_slot_y <- rk.XML.varslot("Second data.frame (y)", source="mjoin_selector_y", required=TRUE, id.name="mjoin_y")

  mjoin_op_dropdown <- rk.XML.dropdown(label="Join Type", options=list(
      "Left Join"=list(val="left_join", chk=TRUE), "Right Join"=list(val="right_join"),
      "Inner Join"=list(val="inner_join"), "Full Join"=list(val="full_join")
  ), id.name="mjoin_op")
  mjoin_by_input <- rk.XML.input(label="Join by columns (e.g., c('A'='B'))", id.name="mjoin_by")
  mjoin_save_obj <- rk.XML.saveobj("Save result as", initial="data.mutated", chk=TRUE, id.name="mjoin_save")

  col_selectors_mjoin <- rk.XML.col(mjoin_selector_x, mjoin_selector_y)
  col_slots_mjoin <- rk.XML.col(mjoin_slot_x, mjoin_slot_y)
  col_options_mjoin <- rk.XML.col(
    rk.XML.frame(mjoin_op_dropdown, mjoin_by_input, label="Join Options"),
    mjoin_save_obj
  )

  mjoin_dialog <- rk.XML.dialog(
    label="Mutating Joins (dplyr)",
    child=rk.XML.row(col_selectors_mjoin, col_slots_mjoin, col_options_mjoin)
  )

  # --- JS Logic (Mutating Joins) ---
  js_calc_mjoin <- '
    var x_df = getValue("mjoin_x");
    var y_df = getValue("mjoin_y");
    var op = getValue("mjoin_op");
    var by = getValue("mjoin_by");
    var command = "data.mutated <- " + op + "(" + x_df + ", " + y_df;
    if(by){ command += ", by=" + by; }
    command += ")";
    echo(command + "\\n");
  '
  js_print_mjoin <- '
    var save_name = getValue("mjoin_save.objectname");
    if(getValue("mjoin_save.active")){
      echo("rk.header(\\"Join result saved as: " + save_name + "\\", level=3)\\n");
      echo("rk.print(head(data.mutated))\\n");
    }
  '

  mjoin_component <- rk.plugin.component(
      "Mutating Joins",
      xml=list(dialog=mjoin_dialog),
      js=list(require="dplyr", calculate=js_calc_mjoin, printout=js_print_mjoin),
      hierarchy=list("data", "Combine Data Tables (dplyr)")
  )

  # =========================================================================================
  # Component 3: Filtering Joins
  # =========================================================================================
  # --- UI Definition (Filtering Joins) - Added labels to varselectors ---
  fjoin_selector_x <- rk.XML.varselector(label="Select data.frame x", id.name="fjoin_selector_x")
  fjoin_slot_x <- rk.XML.varslot("Filter this data.frame (x)", source="fjoin_selector_x", required=TRUE, id.name="fjoin_x")
  fjoin_selector_y <- rk.XML.varselector(label="Select data.frame y", id.name="fjoin_selector_y")
  fjoin_slot_y <- rk.XML.varslot("Using matches in (y)", source="fjoin_selector_y", required=TRUE, id.name="fjoin_y")
  fjoin_op_dropdown <- rk.XML.dropdown(label="Join Type", options=list(
    "Semi Join (keep matching x)"=list(val="semi_join", chk=TRUE), "Anti Join (discard matching x)"=list(val="anti_join")
  ), id.name="fjoin_op")
  fjoin_by_input <- rk.XML.input(label="Join by columns (e.g., 'ID')", id.name="fjoin_by")
  fjoin_save_obj <- rk.XML.saveobj("Save result as", initial="data.filtered", chk=TRUE, id.name="fjoin_save")

  col_selectors_fjoin <- rk.XML.col(fjoin_selector_x, fjoin_selector_y)
  col_slots_fjoin <- rk.XML.col(fjoin_slot_x, fjoin_slot_y)
  col_options_fjoin <- rk.XML.col(
    rk.XML.frame(fjoin_op_dropdown, fjoin_by_input, label="Join Options"),
    fjoin_save_obj
  )

  fjoin_dialog <- rk.XML.dialog(
    label="Filtering Joins (dplyr)",
    child=rk.XML.row(col_selectors_fjoin, col_slots_fjoin, col_options_fjoin)
  )

  # --- JS Logic (Filtering Joins) ---
  js_calc_fjoin <- '
    var x_df = getValue("fjoin_x");
    var y_df = getValue("fjoin_y");
    var op = getValue("fjoin_op");
    var by = getValue("fjoin_by");
    var command = "data.filtered <- " + op + "(" + x_df + ", " + y_df;
    if(by){ command += ", by=" + by; }
    command += ")";
    echo(command + "\\n");
  '
  js_print_fjoin <- '
    var save_name = getValue("fjoin_save.objectname");
    if(getValue("fjoin_save.active")){
      echo("rk.header(\\"Filter result saved as: " + save_name + "\\", level=3)\\n");
      echo("rk.print(head(data.filtered))\\n");
    }
  '

  fjoin_component <- rk.plugin.component(
      "Filtering Joins",
      xml=list(dialog=fjoin_dialog),
      js=list(require="dplyr", calculate=js_calc_fjoin, printout=js_print_fjoin),
      hierarchy=list("data", "Combine Data Tables (dplyr)")
  )

  # =========================================================================================
  # Component 4: Set Operations
  # =========================================================================================
  # --- UI Definition (Set Operations) - Added labels to varselectors ---
  setop_selector_x <- rk.XML.varselector(label="Select data.frame x", id.name="setop_selector_x")
  setop_slot_x <- rk.XML.varslot("First data.frame (x)", source="setop_selector_x", required=TRUE, id.name="setop_x")
  setop_selector_y <- rk.XML.varselector(label="Select data.frame y", id.name="setop_selector_y")
  setop_slot_y <- rk.XML.varslot("Second data.frame (y)", source="setop_selector_y", required=TRUE, id.name="setop_y")
  setop_op_dropdown <- rk.XML.dropdown(label="Operation", options=list(
    "Intersect (common rows)"=list(val="intersect", chk=TRUE),
    "Set Difference (rows in x, not y)"=list(val="setdiff"),
    "Union (all unique rows)"=list(val="union")
  ), id.name="setop_op")
  setop_save_obj <- rk.XML.saveobj("Save result as", initial="data.set", chk=TRUE, id.name="setop_save")

  col_selectors_setop <- rk.XML.col(setop_selector_x, setop_selector_y)
  col_slots_setop <- rk.XML.col(setop_slot_x, setop_slot_y)
  col_options_setop <- rk.XML.col(
    rk.XML.frame(setop_op_dropdown, label="Set Options"),
    setop_save_obj
  )

  setop_dialog <- rk.XML.dialog(
    label="Set Operations (dplyr)",
    child=rk.XML.row(col_selectors_setop, col_slots_setop, col_options_setop)
  )

  # --- JS Logic (Set Operations) ---
  js_calc_setop <- '
    var x_df = getValue("setop_x");
    var y_df = getValue("setop_y");
    var operation = getValue("setop_op");
    echo("data.set <- " + operation + "(" + x_df + ", " + y_df + ")\\n");
  '
  js_print_setop <- '
    var save_name = getValue("setop_save.objectname");
    if(getValue("setop_save.active")){
      echo("rk.header(\\"Set result saved as: " + save_name + "\\", level=3)\\n");
      echo("rk.print(head(data.set))\\n");
    }
  '

  setop_component <- rk.plugin.component(
      "Set Operations",
      xml=list(dialog=setop_dialog),
      js=list(require="dplyr", calculate=js_calc_setop, printout=js_print_setop),
      hierarchy=list("data", "Combine Data Tables (dplyr)")
  )

  # =========================================================================================
  # Final Plugin Skeleton Call
  # =========================================================================================
  rk.plugin.skeleton(
    about = package_about,
    dependencies = dependencies.info,
    xml = list(dialog = main_dialog),
    js = list(require = "dplyr", calculate = js_calc_main, printout = js_print_main),
    rkh = list(help = help_main),
    components = list(mjoin_component, fjoin_component, setop_component),
    pluginmap = list(
        name = "Combine by Binding",
        hierarchy = list("data", "Combine Data Tables (dplyr)")
    ),
    path = ".",
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\nPlugin package 'rk.dplyr' with 4 plugins generated under the 'Data -> Combine Data Tables (dplyr)' menu.\n")
})
