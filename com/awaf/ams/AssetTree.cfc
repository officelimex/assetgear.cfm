component returnFormat="json" {
  
  remote array function default() returnType="array" {
    var locs = queryExecute("SELECT * FROM location WHERE ParentLocationId IS NULL");
    var assets = [];
    
    for(var loc in locs) {
      assets.append({
        "id": "loc_" & loc.LocationId,  // Prefix with "loc_"
        "originalId": loc.LocationId,    // Keep original ID for operations
        "text": loc.Name,
        "icon": "fas fa-industry",
        "children": true,
        "type": "location"
      });
    }
    
    return assets;
  }

  remote array function getChildren(required string parentId) returnType="array" returnFormat="json" {
    // Extract the original ID from the prefixed ID
    var originalParentId = parentId;
    if (parentId.startsWith("loc_")) {
      originalParentId = replace(parentId, "loc_", "");
    } else if (parentId.startsWith("asset_")) {
      originalParentId = replace(parentId, "asset_", "");
    }
    
    var locs = queryExecute("SELECT * FROM location WHERE ParentLocationId = #val(originalParentId)#");
    var children = [];
    
    for(var loc in locs) {
      children.append({
        "id": "loc_" & loc.LocationId,   // Prefix with "loc_"
        "originalId": loc.LocationId,     // Keep original ID
        "text": loc.Name,
        "icon": "fas fa-map-signs",
        "children": true,
        "type": "location"
      });
    }
    
    var assets = queryExecute("
      SELECT a.AssetId, al.AssetLocationId, a.Description, l.Name FROM asset_location al 
      INNER JOIN asset a ON a.AssetId = al.AssetId	
      INNER JOIN location l ON l.LocationId = al.LocationId
      WHERE al.LocationId = #val(originalParentId)#
    ");
    
    for(var a in assets) {
      var icon = "fas fa-cog"
      if (a.Description.findNoCase("fire")) {
        icon = "fas fa-fire-extinguisher";
      }
      if (a.Description.findNoCase("fuel")) {
        icon = "fas fa-oil-can";
      } 
      if (a.Description.findNoCase("gas")) {
        icon = "fas fa-gas-pump";
      }
      if (a.Description.findNoCase("engine")) {
        icon = "fas fa-cogs";
      }
      if (a.Description.findNoCase("pump")) {
        icon = "fas fa-gas-pump";
      }
      if(a.Description.findNoCase("cool")) {
        icon = "fas fa-temperature-low"
      }
      if(a.Description.findNoCase("compressor")) {
        icon = "fas fa-compress-arrows-alt"
      }
      if(a.Description.findNoCase("panel")) {
        icon = "fas fa-microchip";
      }
      if(a.Description.findNoCase("package")) {
        icon = "fas fa-cube";
      }
      if(a.Description.findNoCase("flare")) {
        icon = "fab fa-gripfire";
      }
      if(a.Description.findNoCase("storage")) {
        icon = "fas fa-warehouse";
      }
      if(a.Description.findNoCase("storage")) {
        icon = "fas fa-database rotate-90";
      }
      if(a.Description.findNoCase("gate")) {
        icon = "fas fa-torii-gate";
      }
      if (a.Description.findNoCase("Fan")) {
        icon = "fas fa-fan";
      } 
      /* <i class="fas fa-snowplow"></i> */
      children.append({
        "id": "asset_" & a.AssetId,      // Prefix with "asset_"
        "originalId": a.AssetId,         // Keep original ID
        "aid": a.AssetLocationId,        // Keep asset location ID
        "text": a.Description,
        "icon": "#icon#",
        "children": false,
        "type": "asset"
      });
    }

    
    return children;
  }

  remote struct function move(required string id, required string parent, required numeric position, required string type) returnFormat="json" {
    // Extract original IDs
    var originalId = id;
    var originalParent = parent;
    
    if (id.startsWith("loc_")) {
      originalId = replace(id, "loc_", "");
    } else if (id.startsWith("asset_")) {
      originalId = replace(id, "asset_", "");
    }
    
    if (parent.startsWith("loc_")) {
      originalParent = replace(parent, "loc_", "");
    } else if (parent.startsWith("asset_")) {
      originalParent = replace(parent, "asset_", "");
    }
    
    // Rest of the function using originalId and originalParent
    if (type == "asset" and left(parent,3) == "a") {
      var parentType = queryExecute("
          SELECT a.AssetId 
          FROM asset a 
          WHERE a.AssetId = :parentId
      ", {parentId: originalParent});
      
      if (parentType.recordCount > 0) {
          return {
            "success": false,
            "message": "Cannot move an asset under another asset op:#id# - or:#parent#",
            "type": type
          };
      }
    }  
    
    // Handle location move
    if (type == "location") {
      var parentValue = isNumeric(originalParent) ? originalParent : nullValue();
      queryExecute("
        UPDATE location 
        SET ParentLocationId = :parentId 
        WHERE LocationId = :id
      ", {parentId: parentValue, id: originalId});
    }
    
    // Handle asset move
    if (type == "asset") {
      queryExecute("
        UPDATE asset_location 
        SET LocationId = :parentId 
        WHERE AssetId = :id
      ", {parentId: originalParent, id: originalId});
    }
      
    return {
      "success": true,
      "message": "Node moved successfully",
      "type": type
    };
  }

  remote struct function update(required string id, required string name, required string type) returnFormat="json" {
    var queryResult;
    var originalId = id;
    
    if (id.startsWith("loc_")) {
      originalId = replace(id, "loc_", "");
    } else if (id.startsWith("asset_")) {
      originalId = replace(id, "asset_", "");
    }
  
    if (type == "location") {
      queryResult = queryExecute("
        UPDATE location 
        SET Name = :name 
        WHERE LocationId = :id
      ", {name: name, id: originalId});
    } else if (type == "asset") {
      queryResult = queryExecute("
        UPDATE asset 
        SET Description = :name 
        WHERE AssetId = :id
      ", {name: name, id: originalId});
    }
  
    return {
      "success": queryResult.recordCount > 0,
      "message": "Node updated successfully",
      "type": type
    };
  }

  remote any function create(required string name, required string parent, required string type) returnFormat="json" {
    var result = {};
    var newId = 0;
    var originalParent = parent;
    
    if (parent.startsWith("loc_")) {
      originalParent = replace(parent, "loc_", "");
    } else if (parent.startsWith("asset_")) {
      originalParent = replace(parent, "asset_", "");
    }
  
    if (type == "location") {
      queryExecute("
        INSERT INTO location (Name, ParentLocationId)
        VALUES (:name, :parent)
      ", {name: name, parent: originalParent}, {result="result"});
      newId = result.generated_key;
    } else if (type == "asset") {
      queryExecute("
        INSERT INTO asset (Description)
        VALUES (:name)
      ", {name: name}, {result="result"});
      newId = result.generated_key;
      
      queryExecute("
        INSERT INTO asset_location (AssetId, LocationId)
        VALUES (:assetId, :parentId)
      ", {assetId: newId, parentId: originalParent});
    }

    return {
      "success": true,
      "message": "Node created successfully",
      "id": type == "location" ? "loc_" & newId : "asset_" & newId,  // Return prefixed ID
      "originalId": newId,
      "type": type
    }
  }
}
