/// @description smf_pose_replace_bone(targetPose, sourcePose, boneIndex)
/// @param targetPose
/// @param sourcePose
/// @param boneIndex
var targetPose, sourcePose, bone, i, j;
targetPose = argument0;
sourcePose = argument1;
bone = argument2;
i = 8;
j = bone * 8;
while i--{targetPose[@ j + i] = sourcePose[j + i];}