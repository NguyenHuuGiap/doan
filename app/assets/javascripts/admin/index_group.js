jQuery(document).ready(function() {
  var all;
  var thisemp;
  var nodeIdCounter = -1;
  var levelColors = ["#AC193D/#BF1E4B", "#2672EC/#2E8DEF", "#8C0095/#A700AE",
    "#5133AB/#643EBF", "#008299/#00A0B1", "#D24726/#DC572E",
    "#008A00/#00A600", "#094AB2/#0A5BC4"];
  init();
  function init() {
    if (window.goSamples) goSamples();
    var $ = go.GraphObject.make;
    var enabled = false;
    var readonly = true;
    if(current_user_role === true)
    {
      enabled = true;
      readonly = false;
    }
    GroupDiagram =
      $(go.Diagram, "group-div",
        {
          initialContentAlignment: go.Spot.Center,
          maxSelectionCount: 1,
          validCycle: go.Diagram.CycleDestinationTree,
          layout:
            $(go.TreeLayout,
              {

                treeStyle: go.TreeLayout.StyleLastParents,
                arrangement: go.TreeLayout.ArrangementHorizontal,
                angle: 90,
                layerSpacing: 35,
                alternateAngle: 90,
                alternateLayerSpacing: 35,
                alternateAlignment: go.TreeLayout.AlignmentBus,
                alternateNodeSpacing: 20
              }),
          allowDelete: false,
          allowCopy: false,
          "undoManager.isEnabled": true,
          "contextMenuTool.isEnabled": enabled,
          isReadOnly: false
        });
      $(go.Overview, "group-overview-div",
        { observed: GroupDiagram, contentAlignment: go.Spot.Center });

    GroupDiagram.addDiagramListener("Modified", function(e) {
      var button = document.getElementById("SaveButton");
      if (button) button.disabled = !GroupDiagram.isModified;
      var idx = document.title.indexOf("*");
      if (GroupDiagram.isModified) {
        if (idx < 0) document.title += "*";
      } else {
        if (idx >= 0) document.title = document.title.substr(0, idx);
      }
    });
    GroupDiagram.addDiagramListener("SelectionDeleting", function(e) {
      var part = e.subject.first();
      GroupDiagram.startTransaction("clear boss");
      if (part instanceof go.Node) {
        var it = part.findTreeChildrenNodes();
        while(it.next()) {
          var child = it.value;
          var bossText = child.findObject("boss");
          if (bossText === null) return;
          bossText.text = undefined;
        }
      } else if (part instanceof go.Link) {
        child = part.toNode;
        bossText = child.findObject("boss");
        if (bossText === null) return;
        bossText.text = undefined;
      }
      GroupDiagram.commitTransaction("clear boss");
    });

    GroupDiagram.layout.commitNodes = function() {
      go.TreeLayout.prototype.commitNodes.call(GroupDiagram.layout);
      GroupDiagram.layout.network.vertexes.each(function(v) {
        if (v.node) {
          var level = v.level % (levelColors.length);
          var colors = levelColors[level].split("/");
          var shape = v.node.findObject("SHAPE");
          if (shape) shape.fill = $(go.Brush, "Linear",
            { 0: colors[0], 1: colors[1], start: go.Spot.Left, end: go.Spot.Right });
        }
      });
    };
    function getNextKey() {
      var key = nodeIdCounter;
      while (GroupDiagram.model.findNodeDataForKey(key.toString()) !== null) {
        key = nodeIdCounter -= 1;
      }
      return key.toString();
    }

    function mayWorkFor(node1, node2) {
      if (!(node1 instanceof go.Node)) return false;
      if (node1 === node2) return false;
      if (node2.isInTreeOf(node1)) return false;
      return true;
    }

    function textStyle() {
      return { font: "9pt  Segoe UI,sans-serif", stroke: "white" };
    }

    GroupDiagram.nodeTemplate =  //node cho tung user
      $(go.Node, "Auto",
        {
          doubleClick: function(e, node) {
            if(current_user_role === true)
            {
              window.location.assign("../dashboard/groups/" + node.data.key + "/user_groups");
            }
          },
          mouseDragEnter: function (e, node, prev) {
            var diagram = node.diagram;
            var selnode = diagram.selection.first();
            if (!mayWorkFor(selnode, node)) return;
            var shape = node.findObject("SHAPE");
            if (shape) {
              shape._prevFill = shape.fill;
              shape.fill = "darkred";
            }
          },
          mouseDragLeave: function (e, node, next) {
            console.log(node.data);
            var shape = node.findObject("SHAPE");
            if (shape && shape._prevFill) {
              shape.fill = shape._prevFill;
            }
          },
          mouseDrop: function (e, node) {
            console.log(e);
            var diagram = node.diagram;
            var selnode = diagram.selection.first();
            if (mayWorkFor(selnode, node)) {
              var link = selnode.findTreeParentLink();
              if (link !== null) {
                link.fromNode = node;
              } else {
                diagram.toolManager.linkingTool.insertLink(node, node.port, selnode, selnode.port);
              }
            }
            all = GroupDiagram.model.nodeDataArray;
            jQuery.ajax({
              type: 'POST',
              url: '/admin/users/' + node.data.key,
              data: {
                _method: "patch",
                nodeDataArray: all
              },
              dataType: 'json',
              success: function(data){
                if(data.status === 200)
                {
                  var promise = new Promise(function(resolve, reject) {
                    resolve(GroupDiagram.model = new go.TreeModel(data.content.group_service))
                  });
                  promise.then(function() {
                    setTimeout(function(){ searchDiagram(node.data.key_search); }, 500)
                  })
                  jQuery.bootstrapGrowl(data.message, {
                    delay: 700,
                    type: 'success'
                  });
                }
                else{
                  jQuery.bootstrapGrowl(data.message,{
                    type: 'danger'
                  });
                }
              },
              error: function(XMLHttpRequest, textStatus, errorThrown){
                BootstrapDialog.alert('some error' + textStatus + ' | ' + errorThrown);
              }
            });
          }
        },
        new go.Binding("text", "name"),
        new go.Binding("layerName", "isSelected",
          function(sel) { return sel ? "Foreground" : ""; }).ofObject(),
        $(go.Shape, "Rectangle",
          {
            name: "SHAPE", fill: "white", stroke: null, strokeWidth: 5,
            portId: "", cursor: "pointer"
          },
          new go.Binding("stroke", "isHighlighted",
            function(h) { return h ? "#45F222" : null; }).ofObject()),
        $(go.Panel, "Horizontal",
          $(go.Picture,
            {
              name: 'Picture',
              desiredSize: new go.Size(39, 50),
              margin: new go.Margin(6, 8, 6, 10)
            },
            new go.Binding("source", "image")),
          $(go.Panel, "Table",
            {
              maxSize: new go.Size(150, 999),
              margin: new go.Margin(6, 10, 0, 3),
              defaultAlignment: go.Spot.Left
            },
            $(go.RowColumnDefinition, { column: 2, width: 4 }),
            $(go.TextBlock, textStyle(),
              {
                row: 0, column: 0, columnSpan: 5,
                font: "12pt Segoe UI,sans-serif",
                isMultiline: false,
                minSize: new go.Size(10, 16)
              },
              new go.Binding("text", "name").makeTwoWay()),

            $(go.TextBlock, "Trainer: ", textStyle(),
              { row: 1, column: 0 }),
            $(go.TextBlock, textStyle(),
              {
                row: 1, column: 1, columnSpan: 4,
                isMultiline: false,
                minSize: new go.Size(10, 16)
              },
              new go.Binding("text", "trainer").makeTwoWay())

            // $(go.TextBlock, I18n.t("dashboard.groups.total_user"), textStyle(),
            //   { row: 1, column: 0 }),
            // $(go.TextBlock, textStyle(),
            //   {
            //     row: 1, column: 1, columnSpan: 4,
            //     margin: new go.Margin(0, 0, 0, 3),
            //     isMultiline: false,
            //     minSize: new go.Size(10, 13)
            //   },
            //   new go.Binding("text", "total").makeTwoWay())
          ),
          $("TreeExpanderButton")
        )
      );

  var cxTool = GroupDiagram.toolManager.contextMenuTool;

  var cxElement = document.getElementById("contextMenu");

  cxElement.addEventListener("contextmenu", function(e) {
    this.focus();
    e.preventDefault();
    return false;
  }, false);
  cxElement.addEventListener("blur", function(e) {
    cxTool.stopTool();

    if (cxTool.canStart()) {
      GroupDiagram.currentTool = cxTool;
      cxTool.doMouseUp();
    }

  }, false);
  cxElement.tabIndex = "1";

  cxTool.showContextMenu = function(contextmenu, obj) {
    if (obj !== null)
    {
      thisemp = obj.data;
    }
    var diagram = this.diagram;
    if (diagram === null) return;

    if (contextmenu !== this.currentContextMenu) {
      this.hideContextMenu();
    }

    var cmd = diagram.commandHandler;
    var objExists = obj !== null;
    document.getElementById("new-group").style.display = objExists ? "none" : "block";
    document.getElementById("add-user-group").style.display = objExists ? "block" : "none";
    document.getElementById("new-group-object").style.display = objExists ? "block" : "none";
    document.getElementById("edit-group").style.display = objExists ? "block" : "none";
    document.getElementById("delete-group").style.display = objExists ? "block" : "none";
    document.getElementById("detail-user-group").style.display = objExists ? "block" : "none";
    cxElement.style.display = "block";
    var mousePt = diagram.lastInput.viewPoint;
    cxElement.style.left = mousePt.x + "px";
    cxElement.style.top = mousePt.y + "px";
    this.currentContextMenu = contextmenu;

  cxTool.hideContextMenu = function() {
    if (this.currentContextMenu === null) return;
    cxElement.style.display = "none";
    this.currentContextMenu = null;
  }
  }

    GroupDiagram.contextMenu =
      $(go.Adornment, "Vertical"
      );
    GroupDiagram.nodeTemplate.contextMenu =
      $(go.Adornment, "Vertical"
      );

    GroupDiagram.linkTemplate =
      $(go.Link, go.Link.Orthogonal,
        { corner: 5 },
        $(go.Shape, { strokeWidth: 4, stroke: "#00a4a4" }));
    load(user_service);
  }

  function load(group_service) {
    GroupDiagram.model = new go.TreeModel(
      group_service
    )
  }
  function newGroup() {
    jQuery("#new_group").attr("method", "post");
    jQuery("#group_id").attr("value", "");
    jQuery("#new_group").attr("action",
      "/dashboard/groups/");
    jQuery("#group_name").val("");
    jQuery("#group_description").val("");
    jQuery("#group_closest_parent_id").val("");
    jQuery("#group_parent_path").val("");
    jQuery("#modal-organization").modal('show');
  }

  function newGroupChildren() {
    if (thisemp !== null) {
      jQuery("#new_group").attr("method", "post");
      jQuery("#group_id").attr("value", "");
      jQuery("#new_group").attr("action",
        "/dashboard/groups/");
      jQuery("#group_name").val("");
      jQuery("#group_description").val("");
      jQuery("#group_closest_parent_id").val(thisemp.key);
      jQuery("#group_parent_path").val(thisemp.parent_path);
      jQuery("#modal-organization").modal('show');
    }
  }

  function editGroup() {
    if (thisemp !== null) {
      jQuery("#new_group").attr("method", "post");
      jQuery("#group_id").attr("value", "patch");
      jQuery("#new_group").attr("action",
        "/dashboard/groups/" + thisemp.key);
      jQuery("#group_name").val(thisemp.name);
      jQuery("#group_description").val(thisemp.description);
      jQuery("#group_closest_parent_id").val(thisemp.parent);
      jQuery("#group_parent_path").val(thisemp.parent_path);
      jQuery("#modal-organization").modal('show');
    }
  }

  function addUser() {
    jQuery.ajax({
      type: 'GET',
      url: '/dashboard/organization_charts',
      data: {
        group: thisemp.key
      },
      dataType: 'json',
      success: function(data){
        jQuery('#select-all-user-outside').prop('checked', false);
        jQuery('#assign-list-user-group-search').val("");
        jQuery('#group-body').css('opacity', 1);
        jQuery('.loader').addClass("hide");
        jQuery(".list-group-item").remove();
        jQuery.each(data["user_group"], function(key, value){
          var html = '<li class="list-group-item hide-user-group-search">' +
            '<div class="col-xs-12 col-sm-8">' +
            '<div class="checkbox col-sm-8 checkbox-user-group search-checkbox">' +
            '<label for="user_groups_user_ids_' + value.id + '">' +
            '<input type="checkbox" value="' + value.id +
            '" name="user_groups[user_ids][]"' +
            'id="user_groups_user_ids_' + value.id + '">' + value.name +
            '</label></div>' +
            '<div class="col-xs-12 col-sm-4">' +
            '<img class="img-scale img-circle"' +
            'src="' + value.avatar + '" alt="User avatar default">' +
            '</div></div>' + '<div class="col-sm-4" id="groups-name-' +
            value.id + '">' +
            '</div><div class="clearfix"></div></li>';
          jQuery("#check-box-all-checked").append(html);
          jQuery.each(value.groups, function(index, group){
            var valueid = '#groups-name-' + value.id
            var html_group = '<label class="label-info label-custom" id="lable-group">' +
              group + '</label>';
            jQuery(valueid).append(html_group);
          });
        });
        jQuery("#organization_charts_id").attr("action",
          "/dashboard/groups/" + thisemp.key + "/user_groups");
        jQuery("#add-users-into-group").modal('show');
      }
    });
  }

  function deleteGroup() {
    BootstrapDialog.confirm(
    {
      title: I18n.t("dashboard.groups.warning_group"),
      message: I18n.t("dashboard.groups.confirm"),
      type: BootstrapDialog.TYPE_WARNING,
      closable: true,
      btnCancelLabel: I18n.t("dashboard.groups.no_group"),
      btnOKLabel: I18n.t("dashboard.groups.yes_group"),
      callback: function(result)
      {
        if(result)
        {
          jQuery.ajax({
            type: 'DELETE',
            url: '/dashboard/groups/' + thisemp.key,
            data: {
              nodeDataArray: thisemp
            },
            dataType: 'json',
            success: function(data){
              if(data.status === 200){
                var promise = new Promise(function(resolve, reject) {
                  resolve(load(data.content.group_service))
                });
                promise.then(function() {
                  if(data.content.group !== null){
                    var id_search = data.content.group + thisemp.parent;
                    setTimeout(function(){ searchDiagram(id_search); }, 1000)
                  }
                })
                jQuery.bootstrapGrowl(data.message, {
                  delay: 700,
                  type: 'success'
                });
              }else{
                jQuery.bootstrapGrowl(data.message,{
                  type: 'danger'
                });
              }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown){
              BootstrapDialog.alert('some error' + textxtStatus + ' | ' + errorThrown);
            }
          });
        }
      }
    })
  }

  function detailUserGroup() {
    jQuery.ajax({
      type: 'GET',
      url: '/dashboard/organization_charts',
      data: {
        detail: thisemp.key
      },
      dataType: 'json',
      success: function(data){
        jQuery('#list-user-group-search').val("");
        jQuery('#group-body').css('opacity', 1);
        jQuery('.loader').addClass("hide");
        jQuery(".list-group-item").remove();
        jQuery.each(data["user_group"], function(key, value){
          var html = '<li class="list-group-item hide-user-group-search-detail">' +
            '<div class="col-xs-12 col-sm-8">' +
            '<div class="checkbox col-sm-8 checkbox-user-group-detail search-checkbox-detail">' +
            '<label for="user_groups_user_ids_' + value.id + '">' +
            '<input type="checkbox" value="' + value.id +
            '" name="user_groups[user_ids][]"' +
            'id="user_groups_user_ids_' + value.id + '">' + value.name +
            '</label></div>' +
            '<div class="col-xs-12 col-sm-4">' +
            '<img class="img-scale img-circle"' +
            'src="' + value.avatar + '" alt="User avatar default">' +
            '</div></div>' + '<div class="col-sm-4" id="groups-name-' +
            value.id + '">' +
            '</div><div class="clearfix"></div></li>';
          jQuery("#show-all-user").append(html);
          jQuery.each(value.groups, function(index, group){
            var valueid = '#groups-name-' + value.id
            var html_group = '<label class="label-info label-custom" id="lable-group">' +
              group + '</label>';
            jQuery(valueid).append(html_group);
          });
        });
        jQuery("#organization_charts_id_detail").attr("action",
          "/dashboard/groups/" + thisemp.key + "/user_groups");
        jQuery("#show-users-into-group").modal('show');
      }
    });
  }

  function ajax_organization_charts(btn_id, into_group, id_organization, form_organization, type_form){
    jQuery(btn_id).on('click', function(e){
      jQuery(into_group).modal('hide');
      jQuery('#group-body').css('opacity', 0.5);
      jQuery('.loader').removeClass("hide");
      var action = jQuery(id_organization).attr('action');
      e.preventDefault();
      jQuery.ajax({
        type: type_form,
        url: action,
        data: jQuery(form_organization).serialize(),
        success: function(data){
          jQuery('#group-body').css('opacity', 1);
          jQuery('.loader').addClass("hide");
          if(data.status === 200){
            var promise = new Promise(function(resolve, reject) {
              resolve(load(data.content.group_service))
            });
            promise.then(function() {
              setTimeout(function(){ searchDiagram(data.content.group); }, 1000);
            })
            jQuery.bootstrapGrowl(data.message, {
              delay: 700,
              type: 'success'
            });
          }else{
            jQuery.bootstrapGrowl(data.message, {
              type: 'danger'
            });
          }
        },
        error: function(XMLHttpRequest, textStatus, errorThrown){
          BootstrapDialog.alert('some error' + textxtStatus + ' | ' + errorThrown);
        }
      });
    });
  }

  function searchDiagram(input) {
    if (!input) return;
    var regex = new RegExp(input, "i");
    GroupDiagram.startTransaction("highlight search");
    GroupDiagram.clearHighlighteds();

    if (input) {
      var results = GroupDiagram.findNodesByExample({ name: regex}, {key_search: regex });
      if (results.count === 0)
      {
        BootstrapDialog.alert({
          title: I18n.t("dashboard.groups.warning_group"),
          message: I18n.t("dashboard.groups.message_alert")
        });
      }
      GroupDiagram.highlightCollection(results);
      if (results.count > 0) GroupDiagram.centerRect(results.first().actualBounds);
    }
    GroupDiagram.commitTransaction("highlight search");
  }

    jQuery(document).on('submit', 'form#new_group', function(e){
      var form = jQuery(this);
      var formdata = false;
      if (window.FormData){
          formdata = new FormData(form[0]);
      }
      var name = jQuery("#group_name").val();
      var action = jQuery("#new_group").attr('action');
      e.preventDefault();
      jQuery.ajax({
        type: 'POST',
        url: action,
        data: formdata ? formdata : form.serialize(),
        cache       : false,
        contentType : false,
        processData : false,
        success: function(data){
          if(data.status === 200){
            var promise = new Promise(function(resolve, reject) {
              resolve(load(data.content.group_service))
            });
            promise.then(function() {
              var id_search = name + data.content.group;
              setTimeout(function(){ searchDiagram(id_search); }, 1000)
            })
            jQuery.bootstrapGrowl(data.message, {
              delay: 700,
              type: 'success'
            });
          }else{
            jQuery.bootstrapGrowl(data.message, {
              type: 'danger'
            });
          }
        },
        error: function(XMLHttpRequest, textStatus, errorThrown){
          BootstrapDialog.alert('some error' + textxtStatus + ' | ' + errorThrown);
        }
      });
      jQuery("#modal-organization").modal('hide');
    });
    jQuery('.search-id').on('click', function() {
      var input = document.getElementById("search-group");
      searchDiagram(input.value);
    });
    jQuery('#new-group').on('click', function(){
      newGroup();
    });
    jQuery('#detail-user-group').on('click', function(){
      detailUserGroup();
    });
    jQuery('#new-group-object').on('click', function(){
      newGroupChildren();
    });
    jQuery('#edit-group').on('click', function(){
      editGroup();
    });
    jQuery('#delete-group').on('click', function(){
      deleteGroup();
    });
    jQuery('#add-user-group').on('click', function(){
      jQuery('#group-body').css('opacity', 0.5);
      jQuery('.loader').removeClass("hide");
      addUser();
    });
  ajax_organization_charts('#btn-organization-charts', '#add-users-into-group',
    "#organization_charts_id", 'form#organization_charts_id', 'POST');
  ajax_organization_charts('#btn-detail-organization-charts', '#show-users-into-group',
    '#organization_charts_id_detail', 'form#organization_charts_id_detail', 'DELETE');

});
