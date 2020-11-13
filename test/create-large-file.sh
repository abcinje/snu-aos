#please note, the commands below will create unreadable files and should be 
# used for testing file size only. If you're looking for something that has
# lines in it, use /dev/urandom instead of /dev/zero. You'll then be able to
# read the number of lines in that file using `wc -l large-file.1mb.txt`

# Create a 1MB file
#dd if=/dev/zero of=large-file-1mb.txt count=1024 bs=1024

# Create a 10MB file
#dd if=/dev/zero of=large-file-10mb.txt count=1024 bs=10240

# Create a 100MB file
#dd if=/dev/zero of=large-file-100mb.txt count=1024 bs=102400

# Create a 1GB file
#dd if=/dev/zero of=large-file-1gb.txt count=1024 bs=1048576

# Create a 10GB file
#dd if=/dev/zero of=large-file-10gb.txt count=1024 bs=10485760
dd if=/dev/urandom of=large-file-10gb.txt count=1024 bs=10485760

# Create a 100GB file
#dd if=/dev/zero of=large-file-100gb.txt count=1024 bs=104857600

# Create a 1TB file (careful now...)
#dd if=/dev/zero of=large-file-1tb.txt count=1024 bs=1073741824
