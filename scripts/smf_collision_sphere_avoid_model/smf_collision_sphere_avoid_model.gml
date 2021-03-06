/// @description smf_collision_avoid_model(modelIndex, x, y, z, radius, xup, yup, zup)
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param xup
/// @param yup
/// @param zup
/*
Makes the sphere (x, y, z) with the given radius avoid the given model.

Returns an array of the following format:
[x, y, z, xup, yup, zup, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var retUp = [0, 0, 1], success = false, maxDp = -1;
var i, j, k, n, newPos, d, tris, addRadius, success, tempDistance, tempUp, t, u, v, uu, dp, returnUp, tempPos, minDp, maxDp, minDist, nearest, nearestUp, V;

//Read collision header
var modelIndex = argument0;
var colList = modelIndex[| SMF_model.CollisionList];
var octList = modelIndex[| SMF_model.OctreeList];
if octList == -1
{
    if modelIndex[| SMF_model.QuadtreeBuffer] >= 0{
        return smf__collision_avoid_quadtree(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7);}
    return smf__collision_avoid_buffer(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7);
}

//Transform player coordinates
newPos = [argument1 - octList[| 1], argument2 - octList[| 2], argument3 - octList[| 3]];
addRadius = argument4;
returnUp = [argument5, argument6, argument7];
tris = smf__collision_get_region(octList, newPos[0], newPos[1], newPos[2]);
for (i = array_length_1d(tris) - 1; i >= 0; i --)
{
    //----------------------------------Now, if the object is closer than it's supposed to, push it away from the model and return the new coordinates
    tempPos = smf_project_to_triangle(newPos, colList[| tris[i]]);
    tempUp = smf_vector_normalize([newPos[0] - tempPos[0], newPos[1] - tempPos[1], newPos[2] - tempPos[2]]);
    if tempUp[3] <= addRadius and tempUp[3] > 0
    {
        success = true;
        d = [tempPos[0] + tempUp[0] * addRadius - newPos[0], tempPos[1] + tempUp[1] * addRadius - newPos[1], tempPos[2] + tempUp[2] * addRadius - newPos[2]];
        newPos = [newPos[0] + d[0], newPos[1] + d[1], newPos[2] + d[2]];
        dp = dot_product_3d(argument5, argument6, argument7, d[0], d[1], d[2]) / max(point_distance_3d(0, 0, 0, d[0], d[1], d[2]), 0.00001);
        //-------------------------------The triangle that has the most similar normal to the player's up-vector gets saved to the up-vector (and is not used in this script)
        if dp >= maxDp
        {
            maxDp = dp
            returnUp = [tempUp[0], tempUp[1], tempUp[2]];
        }
    }
}

//Transform player coordinates back into object space
return [octList[| 1] + newPos[0], octList[| 2] + newPos[1], octList[| 3] + newPos[2], returnUp[0], returnUp[1], returnUp[2], success];