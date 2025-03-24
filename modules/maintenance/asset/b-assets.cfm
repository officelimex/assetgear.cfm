<!DOCTYPE html>
  <html>
    <head>
      <title>Asset Browser</title>
      <link
        href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css"
        rel="stylesheet"
      />
      <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
        rel="stylesheet"
      />
      <style>
        .rotate-45 {
          transform: rotate(45deg);
        }
        .rotate-90 {
          transform: rotate(90deg);
        }
        .context-menu {
          display: none;
          position: absolute;
          background: white;
          border: 1px solid #ccc;
          box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
          z-index: 1000;
        }
        .context-menu ul {
          list-style: none;
          margin: 0;
          padding: 0;
        }
        .context-menu ul li {
          padding: 8px 12px;
          cursor: pointer;
        }
        .context-menu ul li:hover {
          background: #f0f0f0;
        }
        /* Custom icons for expand/collapse */
        .jstree-default .jstree-open > .jstree-anchor > .jstree-icon {
          background-image: none;
          content: "-";
          font-size: 16px;
          /* color: #000; */
        }
        .jstree-default .jstree-closed > .jstree-anchor > .jstree-icon {
          background-image: none;
          content: "+";
          font-size: 16px;
          /* color: #000; */
        }
        .light-blue {
          color: #007bff;
        }
      </style>
    </head>
    <body>
      <div class="asset-browser-container">
        <div id="asset-tree"></div>
      </div>
  
      <div id="context-menu" class="context-menu">
        <ul>
          <li data-action="edit">Edit Node</li>
          <li data-action="add-sibling">Add Sibling</li>
          <li data-action="add-child">Add Child</li>
        </ul>
      </div>
  
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>
      
      <cfset hasEditPermission = false>
      <cfif request.IsHost OR request.IsMS>
        <cfset hasEditPermission = true>
      </cfif>
      
      <script>
        // Release the $ symbol for use by other libraries
        var jQ = jQuery.noConflict();
        
        // Get permission status from ColdFusion
        var hasEditPermission = <cfoutput>#hasEditPermission#</cfoutput>;
        
        jQ(document).ready(function () {
          // Initialize jsTree
          jQ("#asset-tree")
            .jstree({
              core: {
                check_callback: hasEditPermission, // Only allow modifications if user has permission
                data: function (node, callback) {
                  if (node.id === "#") {
                    // Load the root node
                    jQ.ajax({
                      url: "../../../com/awaf/ams/AssetTree.cfc?method=default",
                      dataType: "json",
                      success: function (data) {
                        callback(data);
                      },
                      error: function () {
                        console.error("Error loading root node.");
                      },
                    });
                  } else {
                    // Load children nodes
                    jQ.ajax({
                      url: "../../../com/awaf/ams/AssetTree.cfc?method=getChildren",
                      type: "POST",
                      data: {
                        parentId: node.id,
                      },
                      dataType: "json",
                      success: function (data) {
                        callback(data);
                      },
                      error: function () {
                        console.error("Error loading children nodes.");
                      },
                    });
                  }
                },
                themes: {
                  icons: true, // Enable custom icons
                },
              },
              plugins: [
                <cfif hasEditPermission>"dnd", "contextmenu",</cfif> 
                "sort"
              ], // Only include editing plugins if user has permission
              sort: function (a, b) {
                return this.get_text(a).toLowerCase() >
                  this.get_text(b).toLowerCase()
                  ? 1
                  : -1;
              },
              <cfif hasEditPermission>
              contextmenu: {
                items: customMenu,
              },
              </cfif>
            })
            <cfif hasEditPermission>
            .on("move_node.jstree", function (e, data) {
              // Handle node movement
              jQ.ajax({
                url: "../../../com/awaf/ams/AssetTree.cfc?method=move",
                type: "POST",
                data: {
                  id: data.node.id,
                  parent: data.parent,
                  position: data.position,
                  type: data.node.original.type // Include type of data being moved
                },
                success: function (response) {
                  console.log("Node moved successfully");
                },
                error: function (xhr, status, error) {
                  console.error("Error moving node:", error);
                  jQ("#asset-tree").jstree(true).refresh();
                },
              });
            })
            </cfif>
            .on("select_node.jstree", function (e, data) {
              // Single click to open children
              if (data.node.children.length === 0) {
                jQ("#asset-tree").jstree("open_node", data.node);
              }
            })
            <cfif hasEditPermission>
            .on("dblclick.jstree", function (e) {
              // Double click to rename node
              var node = jQ("#asset-tree").jstree(true).get_node(e.target);
              if (node) {
                var newName = prompt("Enter new name:", node.text);
                if (newName) {
                  jQ.ajax({
                    url: "../../../com/awaf/ams/AssetTree.cfc?method=update",
                    type: "POST",
                    data: {
                      id: node.id,
                      name: newName,
                      type: node.original.type // Include type of data being updated
                    },
                    success: function (response) {
                      jQ("#asset-tree").jstree(true).rename_node(node, newName);
                    },
                    error: function (xhr, status, error) {
                      console.error("Error updating node:", error);
                    },
                  });
                }
              }
            });
            </cfif>
        
            // Search functionality
            jQ('#search-input').keyup(function () {
              var searchString = jQ(this).val();
              jQ('#asset-tree').jstree('search', searchString);
            });
        
            <cfif hasEditPermission>
            function customMenu(node) {
              const tree = jQ("#asset-tree").jstree(true);
              const isRoot = tree.get_parent(node) === "#"; // Check if the node is root
              const nodeType = node.original.type; // Get the node type
        
              return {
                edit: {
                  label: "Edit Node",
                  action: function (obj) {
                    if (isRoot) {
                      alert("Root node cannot be edited.");
                      return;
                    }
                    const node = tree.get_node(obj.reference);
                    const newName = prompt("Enter new name:", node.text);
        
                    if (newName) {
                      jQ.ajax({
                        url: "../../../com/awaf/ams/AssetTree.cfc?method=update",
                        type: "POST",
                        data: {
                          id: node.id,
                          name: newName,
                          type: node.original.type
                        },
                        success: function (response) {
                          tree.rename_node(node, newName);
                          const newIcon =
                            node.children.length > 0
                              ? "fas fa-map-marked-alt"
                              : "fas fa-oil-can";
                          tree.set_icon(node, newIcon);
                        },
                        error: function (xhr, status, error) {
                          console.error("Error updating node:", error);
                        },
                      });
                    }
                  },
                  _disabled: isRoot, // Disable edit option for root node
                },
                add_location: {
                  label: "New Location",
                  action: function (obj) {
                    const node = tree.get_node(obj.reference);
                    const newName = prompt("Enter name for new location:");
        
                    if (newName) {
                      jQ.ajax({
                        url: "../../../com/awaf/ams/AssetTree.cfc?method=create",
                        type: "POST",
                        data: {
                          name: newName,
                          parent: node.id,
                          type: "location"
                        },
                        success: function (response) {
                          const newIcon = "fas fa-map-signs light-blue";
                          tree.create_node(node, {
                            text: newName,
                            id: response.id, 
                            icon: newIcon,
                            type: "location"
                          });
                        },
                        error: function (xhr, status, error) {
                          console.error("Error creating location:", error);
                        }
                      });
                    }
                  },
                },
                add_asset: {
                  label: "New Asset",
                  action: function (obj) {
                    const node = tree.get_node(obj.reference);
                    if (nodeType !== "location") {
                      alert("Assets can only be added under locations.");
                      return;
                    }
                    const newName = prompt("Enter name for new asset:");
        
                    if (newName) {
                      jQ.ajax({
                        url: "../../../com/awaf/ams/AssetTree.cfc?method=create",
                        type: "POST",
                        data: {
                          name: newName,
                          parent: node.id,
                          type: "asset"
                        },
                        success: function (response) {
                          const newIcon = "fas fa-wrench";
                          tree.create_node(node, {
                            text: newName,
                            id: response.id,
                            icon: newIcon,
                            type: "asset"
                          });
                        },
                      });
                    }
                  },
                }
              };
            }
            </cfif>
        });

        // Update the select_node.jstree event handler
        jQ("#asset-tree").on("select_node.jstree", function (e, data) {
        // Send selected asset information to the parent window
        var selectedAsset = {};
        
        if(data.node.original.type === "asset") {
        // Extract the original ID from the prefixed ID
        var originalId = data.node.id;
        if (data.node.id.startsWith("asset_")) {
        originalId = data.node.id.replace("asset_", "");
        }
        
        selectedAsset = {
        id: originalId,  // Send the original ID without prefix
        prefixedId: data.node.id,  // Also send the prefixed ID if needed
        aid: data.node.original.aid,
        text: data.node.text,
        type: "asset"
        };
        } else if(data.node.original.type === "location") {
        // Extract the original ID from the prefixed ID
        var originalId = data.node.id;
        if (data.node.id.startsWith("loc_")) {
        originalId = data.node.id.replace("loc_", "");
        }
        
        selectedAsset = {
        id: originalId,  // Send the original ID without prefix
        prefixedId: data.node.id,  // Also send the prefixed ID if needed
        text: data.node.text,
        type: "location"
        };
        }
        
        // Add debugging
        console.log("Sending to parent:", selectedAsset);
        
        window.parent.postMessage(selectedAsset, "*");
        });
      </script>
    
      </body>
  </html>

