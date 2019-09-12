/// @param filename

var filename = argument0;

var original = buffer_load(filename);
var erroneous = false;
var header = chr(buffer_read(original, buffer_u8)) + chr(buffer_read(original, buffer_u8)) + chr(buffer_read(original, buffer_u8));

var buffer = buffer_decompress(original);

// if the decompressed buffer is bad, cancel - try catch will make this so much nicer
// @todo gml update try catch
if (buffer < 0) {
    erroneous = true;
} else {
    buffer_seek(buffer, buffer_seek_start, 0);
    
    /*
     * Header
     */
    
    var header = chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8));
    
    if (header == "DDD") {
		Stuff.save_name_data = string_replace(filename_name(filename), EXPORT_EXTENSION_DATA, "");
		
        var version = buffer_read(buffer, buffer_u32);
        var last_safe_version = DataVersions.MAPS_NUKED;
		
        if (version < last_safe_version) {
            show_error("We stopped supporting versions of the data file before " + string(last_safe_version) +
                ". This current version is " + string(version) + ". Please find a version of " + filename_name(filename) +
                " made with a more up-to-date version of the editor.", true);
		}
        
        var what = buffer_read(buffer, buffer_u8);
        var things = buffer_read(buffer, buffer_u32);
		
		Stuff.maps_included = (what == SERIALIZE_DATA_AND_MAP);
        
        switch (what) {
            case SERIALIZE_ASSETS:
                instance_activate_object(Data);
                with (Data) if (file_location = DataFileLocations.ASSET) {
                    instance_destroy();
                }
                ds_list_clear(Stuff.all_meshes);
				ds_list_clear(Stuff.all_bgm);
				ds_list_clear(Stuff.all_se);
                break;
			case SERIALIZE_DATA_AND_MAP:
            case SERIALIZE_DATA:
                instance_activate_object(Data);
                with (Data) if (file_location = DataFileLocations.DATA) {
                    instance_destroy();
                }
                // clear all data - data has already been destroyed so you just have to clear them
                ds_list_clear(Stuff.all_events);
                ds_list_clear(Stuff.all_event_custom);
                ds_list_clear(Stuff.all_event_templates);
                ds_list_clear(Stuff.all_data);
                // these contain arrays, which are garbage collected
                ds_list_clear(Stuff.variables);
                ds_list_clear(Stuff.switches);
                break;
            case SERIALIZE_MAP:
				instance_activate_object(DataMapContainer);
				instance_destroy(DataMapContainer);
				Stuff.active_map = instance_create_depth(0, 0, 0, DataMapContainer);
				Stuff.active_map.contents = instance_create_depth(0, 0, 0, MapContents);
				instance_deactivate_object(Stuff.active_map.contents);
                break;
        }
        
        /*
         * data types
         */
        
        var stop = false;
        while (!stop) {
            var datatype = buffer_read(buffer, buffer_datatype);
            switch (datatype) {
                // assets
                case SerializeThings.AUTOTILES: serialize_load_autotiles(buffer, version); break;
                case SerializeThings.TILESET: serialize_load_tilesets(buffer, version); break;
                case SerializeThings.AUDIO_BGM: serialize_load_audio_bgm(buffer, version); break;
                case SerializeThings.AUDIO_SE: serialize_load_audio_se(buffer, version); break;
                case SerializeThings.MESHES: serialize_load_meshes(buffer, version); break;
                // game stuff
                case SerializeThings.EVENTS: serialize_load_events(buffer, version); break;
                case SerializeThings.MISC_MAP_META: serialize_load_global_meta(buffer, version); break;
                case SerializeThings.DATADATA: serialize_load_datadata(buffer, version); break;
                case SerializeThings.DATA_INSTANCES: serialize_load_data_instances(buffer, version); break;
                case SerializeThings.EVENT_CUSTOM: serialize_load_event_custom(buffer, version); break;
                case SerializeThings.ANIMATIONS: serialize_load_animations(buffer, version); break;
                case SerializeThings.MAPS: serialize_load_maps(buffer, version); break;
                // map stuff
                case SerializeThings.MAP_META: serialize_load_map_contents_meta(buffer, version, Stuff.active_map);  break;
                case SerializeThings.MAP_BATCH: serialize_load_map_contents_batch(buffer, version, Stuff.active_map); break;
                case SerializeThings.MAP_DYNAMIC: serialize_load_map_contents_dynamic(buffer, version, Stuff.active_map); break;
                // end of file
                case SerializeThings.END_OF_FILE: stop = true; break;
            }
        }
		
        switch (what) {
            case SERIALIZE_MAP:
				if (version >= DataVersions.MAPS_NUKED) {
					Stuff.active_map = guid_get(Stuff.game_map_starting);
				} else {
					Stuff.active_map = internal_name_get(Stuff.game_map_starting);
					Stuff.game_map_starting = Stuff.active_map.GUID;
				}
				break;
		}
        
        error_show();
        
        game_auto_title();
    } else {
        erroneous = true;
    }
}

if (erroneous) {
    dialog_create_notice(null, "this is a ddd* file but the contents are no good?");
}

/*
 * that's it!
 */

buffer_delete(buffer);
buffer_delete(original);