/// @description smf_node_get_list(modelIndex)
/// @param modelIndex
/*
Returns a list containing all the nodes in the model
*/
var modelIndex = argument0;
var nodeList = modelIndex[| SMF_model.NodeList];
return nodeList;