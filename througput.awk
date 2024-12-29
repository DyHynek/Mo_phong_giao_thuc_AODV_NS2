BEGIN {
        recvdSize = 0
        startTime = 150
        stopTime = 0
   }
    
   {
              event = $1
              time = $2
              node_id = $3
              pkt_size = $8
              level = $4
    
   # Thời gian bắt đầu lưu trữ
   if (level == "AGT" && event == "s" && pkt_size >= 512) {
     if (time < startTime) {
              startTime = time
              }
        }
    
   # Cập nhật tổng kích thước gói nhận được và thời gian đến của gói lưu trữ
   if (level == "AGT" && event == "r" && pkt_size >= 512) {
        if (time > stopTime) {
              stopTime = time
              }
        
        hdr_size = pkt_size % 512
        pkt_size -= hdr_size
        # Lưu trữ kích thước của gói nhận được
        recvdSize += pkt_size
        }
   }
    
   END {
        printf("Average Throughput[kbps] = %.2f\t\t StartTime=%.2f\tStopTime=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000),startTime,stopTime)
   }
