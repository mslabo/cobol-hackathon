program_name=$1
func_names='drone_begin drone_end drone_command drone_takeoff drone_land drone_up drone_down drone_left drone_right drone_forward drone_back drone_cw drone_ccw drone_flip drone_capture_image get_smile_score init_server is_winner lib_sleep'
filecontent=`cat "$program_name"`

for func_name in $func_names
do
    replace_name=`nm dronelib.so | grep $func_name | awk '{print $ 3}'`
    filecontent=`echo "$filecontent" | sed "s/$func_name/$replace_name/g"`
done
echo "$filecontent" > $2
