/// @param json
/// @param tileset-columns
/// @param z
/// @param alpha
/// @param x
/// @param y
/// @param tiled-cache

var json = argument[0];
var columns = argument[1];
var z = argument[2];
var alpha = (argument_count > 3) ? argument[3] : 1;
var xx = (argument_count > 4) ? argument[4] : 0;
var yy = (argument_count > 5) ? argument[5] : 0;
var tiled_cache = (argument_count > 6) ? argument[6] : noone;
var zz = z;

var layer_objects = json[? "objects"];
var layer_name = json[? "name"];
var layer_alpha = json[? "opacity"];
var layer_visible = json[? "visible"];
var layer_data_x = json[? "x"];
var layer_data_y = json[? "y"];
var layer_base_z = z;

var tmx_cache = tiled_cache[? "&tmx-ids"];

for (var i = 0; i < ds_list_size(layer_objects); i++) {
    var object = layer_objects[| i];
    var obj_id = object[? "id"];
    var obj_x = object[? "x"];
    var obj_y = object[? "y"];
    
    var obj_gid_local = object[? "gid"];
    var obj_name = object[? "name"];
    var obj_template = object[? "template"];
    var obj_properties = object[? "properties"];
    var obj_type = object[? "type"];
    var obj_visible = object[? "visible"];
    var obj_width = object[? "width"];
    var obj_height = object[? "height"];
    
    if ((obj_template == undefined)) {
        var data_template = noone;
        var data_template_root = noone;
    } else {
        var data_template_root = import_map_tiled_get_cached_object(tiled_cache, obj_template);
        var data_template = data_template_root[? "object"];
    }
    
    if (!data_template) {
        if (obj_gid_local == undefined) continue;
        if (obj_name == undefined) continue;
        if (obj_type == undefined) continue;
        if (obj_visible == undefined) continue;
        if (obj_width == undefined) continue;
        if (obj_height == undefined) continue;
        
        var data_gid = obj_gid_local;
        var data_name = obj_name;
        var data_type = obj_type;
        var data_visible = obj_visible;
        var data_width = obj_width;
        var data_height = obj_height;
    } else {
        var data_name = (obj_name == undefined) ? data_template[? "name"] : obj_name;
        var data_type = (obj_type == undefined) ? data_template[? "type"] : obj_type;
        var data_visible = (obj_visible == undefined) ? data_template[? "visible"] : obj_visible;
        var data_width = (obj_width == undefined) ? data_template[? "width"] : obj_width;
        var data_height = (obj_height == undefined) ? data_template[? "height"] : obj_height;
        
        // because this gid system makes everything extremely fun and enjoyable to work with
        if (obj_gid_local == undefined) {
            var ts_object = data_template_root[? "tileset"];
            var ts_base_list = tiled_cache[? "%tilesets"];
            for (var j = 0; j < ds_list_size(ts_base_list); j++) {
                var ts_data = ts_base_list[| j];
                if (string_count(ts_data[? "source"], ts_object[? "source"]) > 0) {
                    var data_gid = ts_data[? "firstgid"] + data_template[? "gid"] - 1 /* i really don't like things that are 1-indexed */;
                    break;
                }
            }
        } else {
            var data_gid = obj_gid_local;
        }
    }
    
    // merging the property maps does not sound like my idea of a fun time, but not doing it would be even worse
    var data_properties = ds_map_create();
    
    // the properties given to the instantiated object go first
    if (obj_properties != undefined) {
        for (var j = 0; j < ds_list_size(obj_properties); j++) {
            var given = obj_properties[| j];
            var property = ds_map_create();
            property[? "name"] = given[? "name"];
            property[? "value"] = given[? "value"];
            ds_map_add_map(data_properties, given[? "name"], property);
        }
    }
    // the properties of the template go last - if any can be found
    if (data_template && data_template[? "properties"] != undefined) {
        var template_properties = data_template[? "properties"];
        if (template_properties != undefined) {
            for (var j = 0; j < ds_list_size(template_properties); j++) {
                var given = template_properties[| j];
                if (!ds_map_exists(data_properties, given[? "name"])) {
                    var property = ds_map_create();
                    property[? "name"] = given[? "name"];
                    property[? "value"] = given[? "value"];
                    ds_map_add_map(data_properties, given[? "name"], property);
                }
            }
        }
    }
    
    // extract the information about the tile the object uses
    var gid_cache = tiled_cache[? "&gid"];
    var gid_to_image_name = gid_cache[? data_gid];
    
    if (gid_to_image_name == undefined) {
        var ts_json_data = noone;
        var ts_base_list = tiled_cache[? "%tilesets"];
        for (var j = ds_list_size(ts_base_list) - 1; j >= 0; j--) {
            var ts_data = ts_base_list[| j];
            if (ts_data[? "firstgid"] <= data_gid) {
                ts_json_data = ts_base_list[| j];
                break;
            }
        }
        
        // i do NOT want to go through this every time so i'm going to cache the result
        // when i can since the gids are [waves hands] global
        var tileset_data = import_map_tiled_get_cached_tileset(tiled_cache, ts_json_data[? "source"]);
        var tileset_tile_data = tileset_data[? "tiles"];
        var tile_id = data_gid - ts_json_data[? "firstgid"];
        for (var j = 0; j < ds_list_size(tileset_tile_data); j++) {
            var tileset_tile_data_object = tileset_tile_data[| j];
            if (tileset_tile_data_object[? "id"] == tile_id) {
                gid_to_image_name = filename_name(filename_change_ext(tileset_tile_data_object[? "image"], ""));
                ds_map_add(gid_cache, data_gid, gid_to_image_name);
            }
        }
        var tileset_tile_individual = tileset_tile_data[| data_gid - ts_json_data[? "firstgid"]];
    }
    
    var instance = noone;
    var update = false;
    
    switch (string_lower(data_type)) {
        case "pawn":
            var pr_cutscene_entrypoint = data_properties[? "CutsceneEntrypoint"];
            var pr_cutscene_entrypoint_name = pr_cutscene_entrypoint[? "value"];
            var pr_static = data_properties[? "Static?"];
            
            if (pr_static == undefined) break;
            
            pr_cutscene_entrypoint = event_get_node_global(pr_cutscene_entrypoint_name);
            pr_static = pr_static[? "value"];
            
            // arrays don't have a truth value apparently
            if (pr_cutscene_entrypoint != undefined) {
                if (tmx_cache[? obj_id]) {
                    instance = tmx_cache[? obj_id];
                    updated = true;
                    var page = instance.object_events[| 0];
                    if (!page) {
                        page = create_instantiated_event("Conversation:" + pr_cutscene_entrypoint[1].name);
                        ds_list_add(instance.object_events, page);
                    } else {
                        page.name = "Conversation:" + pr_cutscene_entrypoint[1].name;
                    }
                    // The entity only needs to be relocated; it doesn't need to be removed from
                    // the lists, or re-added later, because that would take a lot of time
                    map_remove_thing(instance);
                    // position for NPCs is at -1 because of where the origin for sprites is in Tiled
                    map_add_thing(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT - 1, zz, undefined, undefined, false);
                } else {
                    instance = instance_create_pawn();
                    instance.tmx_id = obj_id;
                    var page = create_instantiated_event("Conversation:" + pr_cutscene_entrypoint[1].name);
                    ds_list_add(instance.object_events, page);
                    // position for NPCs is at -1 because of where the origin for sprites is in Tiled
                    map_add_thing(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT - 1, zz);
                }
                page.trigger = 1;   // magic, do not touch
                page.event_guid = pr_cutscene_entrypoint[0].GUID;
                page.event_entrypoint = pr_cutscene_entrypoint[1].GUID;
            } else {
                wtf("Log an error somewhere - no event entrypoint \"" + pr_cutscene_entrypoint_name + "\"" + " for " + data_name);
            }
            break;
        case "mesh":
            var pr_cutscene_entrypoint = data_properties[? "CutsceneEntrypoint"];
            var pr_static = data_properties[? "Static?"];
            var pr_offset_x = data_properties[? "OffsetX"];
            var pr_offset_y = data_properties[? "OffsetY"];
            
            if (pr_cutscene_entrypoint == undefined) break;
            if (pr_static == undefined) break;
            if (pr_offset_x == undefined) pr_offset_x = 0; else pr_offset_x = pr_offset_x[? "value"];
            if (pr_offset_y == undefined) pr_offset_y = 0; else pr_offset_y = pr_offset_y[? "value"];
            
            var pr_cutscene_entrypoint_name = pr_cutscene_entrypoint[? "value"];
            pr_static = pr_static[? "value"];
            
            var pr_mesh_data = internal_name_get(gid_to_image_name);
            if (pr_mesh_data) {
                if (tmx_cache[? obj_id]) {
                    instance = tmx_cache[? obj_id];
                    update = true
                    // The entity only needs to be relocated; it doesn't need to be removed from
                    // the lists, or re-added later, because that would take a lot of time
                    map_remove_thing(instance);
                    map_add_thing(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT, zz, undefined, undefined, false);
                } else {
                    instance = instance_create_mesh(pr_mesh_data);
                    instance.tmx_id = obj_id;
                    map_add_thing(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT, zz);
                }
                instance.off_xx = pr_offset_x / TILE_WIDTH;
                instance.off_yy = pr_offset_y / TILE_HEIGHT;
                instance.static = pr_static;
            } else {
                wtf("Log an error somewhere - no existing mesh \"" + gid_to_image_name + "\"" + " for " + data_name);
            }
            break;
        case "effect":
        default:
            not_yet_implemented_polite();
            break;
    }
    
    if (instance) {
        var property_list = ds_map_to_list(data_properties);
        for (var j = 0; j < ds_list_size(property_list); j++) {
            var property = data_properties[? property_list[| j]];
            var property_name = property[? "name"];
            switch (string_char_at(property_name, 1)) {
                case "@":
                    var data = internal_name_get(property[? "value"]);
                    if (data) {
                        var base = guid_get(data.base_guid);
                        var base_property_name = string_replace(property_name, "@", "");
                        var data_generic_instance = noone;
                        // if there's already a generic data property with the same name, set its
                        // value instead of creating a new one, since you're not really supposed to
                        // have duplicate generic properties
                        if (update) {
                            for (var k = 0; k < ds_list_size(instance.generic_data); k++) {
                                var existing_generic = instance.generic_data[| k];
                                if (existing_generic.name == base_property_name) {
                                    data_generic_instance = existing_generic;
                                    break;
                                }
                            }
                        }
                        if (!data_generic_instance) {
                            var data_generic_instance = instance_create_depth(0, 0, 0, DataAnonymous);
                            data_generic_instance.name = base_property_name;
                            ds_list_add(instance.generic_data, data_generic_instance);
                        }
                        data_generic_instance.value_data = data.GUID;
                        data_generic_instance.value_type_guid = base.GUID;
                        data_generic_instance.type = DataTypes.DATA;
                    } else {
                        wtf("internal name not found - " + property[? "value"]);
                    }
                    break;
                // other sigils may indicate other data types, but that's all for now
            }
        }
        ds_list_destroy(property_list);
    }
    
    ds_map_destroy(data_properties);
}

return z;