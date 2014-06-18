--
-- CakeSchema Export
-- Based on DoctrinExport (http://code.google.com/p/mysql-workbench-doctrine-plugin/)
--
-- Testing
-- catalog= grtV.getGlobal("/wb/doc/physicalModels/0/catalog")
-- CakeSchema:writeToClipboard(catalog)
--
-- standard module/plugin functions
--
 
-- this function is called first by MySQL Workbench core to determine number of plugins in this module and basic plugin info
-- see the comments in the function body and adjust the parameters as appropriate
function getModuleInfo()
    return {
        name= "DBdoc",                     -- put your module name here; must be a valid identifier unique among
                                                        -- all other plugin names
        author= "WebMachine Ltda.",                  -- put your company name here
        version= "1.0",                         -- put module version string in form major.minor
        implements= "PluginInterface",          -- don't change this
        functions= {
                  "getPluginInfo:l<o@app.Plugin>:",     -- don't change this
                  "writeDBdocToFile:i:o@db.Catalog",   -- list all your plugin function names and accepted argument types,
                  "writeDBdocToClipboard:i:o@db.Catalog"   -- keeping the rest unchanged; in this example there's only one
                                                        -- function, function name is PluginFunctionName and argument type
                                                        -- is db.Catalog
        }
    }
end
 
 
-- helper function to create a descriptor for an argument of a specific type of object
-- you don't need to change here anything
function objectPluginInput(type)
    return grtV.newObj("app.PluginObjectInput", {objectStructName= type})
end
 
-- this function is called by MySQL Workbench core after a successful call to getModuleInfo()
-- to gather information about the plugins in this module and the functions that the plugins expose;
-- a plugin should expose only one function that will handle a menu command for a class of objects
-- see the comments in the function body and adjust the parameters as appropriate
function getPluginInfo()
    local l
    local plugin
 
    -- create the list of plugins that this module exports
    l= grtV.newList("object", "app.Plugin")
 
    -- create a new app.Plugin object for every plugin
    plugin= grtV.newObj("app.Plugin", {
        name= "wb.catalog.util.writeDBdocToFile",   -- plugin namespace
                caption= "DBdoc: Write to File",      -- plugin textual description (will appear as menu item name)
        moduleName= "DBdoc",                        -- this should be in sync with what you sepcified previously for module
                                                            -- name in getModuleInfo()
        pluginType= "normal",                            -- don't change this
        moduleFunctionName= "writeDBdocToFile",        -- the function that this plugin exposes
        inputValues= {objectPluginInput("db.Catalog")},  -- the type of object
        rating= 100,                                     -- don't change this
        showProgress= 0,                                 -- don't change this
        groups= {"Catalog/Utilities", "Menu/Catalog"}  -- use "Catalog/Utilities" to show the menu item on the overview page,
                                                                 -- or "Model/Utilities" to show the menu item on the canvas;
                                                                 -- the "Menu/*" entries control how the plugin will appear in main menu
                                                                 -- the possible values for it are "Menu/Model", "Menu/Catalog", "Menu/Objects",
                                                                 -- "Menu/Database", "Menu/Utilities"
    })
 
    -- fixup owner
    plugin.inputValues[1].owner= plugin
    -- add to the list of plugins
    grtV.insert(l, plugin)
 
 
    plugin= grtV.newObj("app.Plugin", {
      name= "wb.catalog.util.writeDBdocToClipboard",
      caption= "DBdoc: Copy to Clipboard",
      moduleName= "DBdoc",
      pluginType= "normal",
      moduleFunctionName= "writeDBdocToClipboard",
      inputValues= {objectPluginInput("db.Catalog")},
      rating= 100,
      showProgress= 0,
      groups= {"Catalog/Utilities", "Menu/Catalog"}
   })
 
    -- fixup owner
    plugin.inputValues[1].owner= plugin
    -- add to the list of plugins
    grtV.insert(l, plugin)
 
    return l
end
 
-- Print some version information and copyright to the output window
function printVersion()
    print("\n\n\nDBdoc v1.0\nCopyright (c) 2011 WebMachine Ltda.");
end
 
--
-- writeDBdocToClipboard definition
-- @param object catalog
--
function writeDBdocToClipboard(catalog)
    printVersion()
    local doc = generateDBdoc(catalog)
    Workbench:copyToClipboard(doc)
    print("\n > DBdoc copied to clipboard")
    return 0
end
 
--
-- writeDBdocToFile definition
-- @param object catalog
--
function writeDBdocToFile(catalog)
    printVersion()
    local doc = generateDBdoc(catalog);
 
    if (catalog.customData["DBdocExportPath"] ~= nil) then
        if (Workbench:confirm("Proceed?", "Do you want to overwrite previously exported file "..catalog.customData["DBdocExportPath"].." ?") == 1) then
            DBdocExportPath = catalog.customData["DBdocExportPath"];
        else
            DBdocExportPath = Workbench:input('Please enter the DBdoc export path');
            if (DBdocExportPath ~= "") then
                -- Try to save the filepath for the next time:
                catalog.customData["DBdocExportPath"] = DBdocExportPath;
            end
        end
    else
        DBdocExportPath = Workbench:input('Please enter the DBdoc export path');
        if (DBdocExportPath ~= "") then
            -- Try to save the filepath for the next time:
            catalog.customData["DBdocExportPath"] = DBdocExportPath;
        end
    end
 
    if DBdocExportPath ~= '' then
        f = io.open(DBdocExportPath, "w");
        if (f ~= nil) then
            doc = string.gsub(doc, "\r", "")
            f.write(f, doc);
            f.close(f);
            print('\n > DBdoc was exported to ' .. DBdocExportPath);
        else
            print('\n > Could not write file ' .. DBdocExportPath);
        end
    else
        print('\n > DBdoc was NOT exported. Path was invalid.');
    end
 
  return 0
end
--
-- generate DBdoc class
-- @param object column
-- @return string
--
function generateDBdoc(catalog)
	local result = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> \n'
	result = result .. '<html xmlns="http://www.w3.org/1999/xhtml"> \n'
	result = result .. '<head> \n'
	result = result .. '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> \n'
	result = result .. '<title>DBdoc</title> \n'
	result = result .. '</head> \n'
	result = result .. '<style type="text/css"> \n'
	result = result .. '	table {width: 100%; border-collapse: collapse;} \n'
	result = result .. '	table, td, th {border: 1px solid black;} \n'
	result = result .. '</style> \n'
	result = result .. '<body> \n'

    for i = 1, grtV.getn(catalog.schemata) do
        schema = catalog.schemata[i]
 		result = result .. '<h1>' .. schema.name .. '</h1> \n'
		
		result = result .. '<ol> \n'
		for j = 1, grtV.getn(schema.tables) do
			table = schema.tables[j]
			result = result .. '<li><a href="#' .. table.name .. '">' .. table.name .. '</a> (' .. grtV.getn(table.columns) .. ' campos)</li>'		
		end
		result = result .. '</ol> \n'
 		
 		result = result .. '<ol> \n'
        for j = 1, grtV.getn(schema.tables) do
			table = schema.tables[j]
			
			result = result .. '<li id="' .. table.name .. '"> \n'
			result = result .. '<h2>' .. table.name .. '</h2> \n'
			result = result .. '<p>' .. table.comment .. '</p> \n'
			
			result = result .. '<table> \n'

			result = result .. '<tr> \n'
			  result = result .. '<th>CAMPO</th> \n'
			  result = result .. '<th>TIPO</th> \n'
			  result = result .. '<th>NULO</th> \n'
			  result = result .. '<th>EXTRA</th> \n'
			  result = result .. '<th>COMENTARIOS</th> \n'
			result = result .. '</tr> \n'

            for k = 1, grtV.getn(table.columns) do
                col = table.columns[k]
			    result = result .. '<tr> \n'
			    result = result .. '   <td>' ..  col.name .. '</td> \n'
			    result = result .. '   <td>' .. col.formattedType .. '</td> \n'
			
			    if (col.isNotNull == 1) then
			        result = result .. '    <td>' ..    'NO' .. '</td> \n'
			    else
			        result = result .. '    <td>' .. 'SI' .. '</td> \n'   
			    end
			
			    if (col.autoIncrement == 1) then
			        result = result .. '    <td>' ..    'AUTO_INCREMENT' .. '</td> \n'
			    else
			        result = result .. '    <td>' ..    ' - ' .. '</td> \n'
			    end
			
			    result = result .. '    <td>' .. col.comment .. '</td> \n'
			    result = result .. '</tr> \n'
            end
            result = result .. '</table> \n'
            result = result .. '</li> \n'
        end
    end
	result = result .. '</ol> \n'
	result = result .. '</body> \n'
	result = result .. '</html>'
	
	return result
end

