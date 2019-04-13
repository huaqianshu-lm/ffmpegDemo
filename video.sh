

path=$1
files=$(ls $path)



for filename in $files

# 裁剪视频（切割大小，长度）
do
   		startTime=0
   		endTime=0
		i=0
		type=".mp4"
		if [[ $filename =~ $type ]]
		then
			# 把视频的信息以 json 的格式返回到 videoinfo 文件中
			ffprobe -print_format json -show_streams $filename > videoinfo

			# 获取视频的宽 、这里的循环用重定向的写法
			while  read line 
			do
				#statements
				if [[ $line =~ 'width' ]]; then
					#statements
					videowidth=`echo $line | awk -F: '{print $2}' | awk -F, '{print $1}'`
					echo $line
					echo 'width' + $videowidth

					break

				fi
			done < videoinfo

			# 获取视频的高
			while  read line 
			do

				if [[ $line =~ 'height' ]]; then
					#statements
					videoheight=`echo $line | awk -F: '{print $2}' | awk -F, '{print $1}'`
					echo $line
					echo 'height' + $videoheight

					# echo "$videowidth"
					break

				fi
			done < videoinfo

			# 获取视频的时长
			while  read line 
			do

				if [[ $line =~ 'duration' ]]; then
					if [[ $line =~ 'duration_ts' ]]; then
					echo $line
				else
					videoduration=`echo $line | awk -F: '{print $2}' | awk -F, '{print $1}' | awk -F '"' '{print $2}'`
					echo $line
					echo 'duration' + $videoduration

					break
					#statements
					fi
				#statements
				fi
			done <  videoinfo




			echo $videowidth
			echo $videoheight

			w=`expr $(($videoheight * $videoheight / $videowidth))`
			h=$videoheight
			x=`expr $(($videowidth/2 - $videoheight * $videoheight/ $videowidth/2))`
			y=0


			echo $w
			echo $h
			echo $x


			# 裁剪视频的大小
			# ffmpeg -i $filename -strict -2 -vf  crop=405:720:437:0  $filename+out.mp4

			ffmpeg -i $filename -strict -2 -vf  crop=$($w:$h:$x:0)  $filename+out.mp4


			echo $duration

			duration=`expr $videoduration | awk -F. '{print $1}'`

			while [ $endTime -le $duration ]; do
    			#statements
    			i=$[$i+1]
    			endTime=$[$startTime+4]
    			# 切割视频的时长
    			ffmpeg -i /Users/limiao/Desktop/video/$filename+out.mp4  -ss $startTime -to $endTime -acodec copy -vcodec copy outvideo/$filename+$i.mp4  
    			startTime=$[endTime]

    		done
    	fi
    done


