package com.ecommerce.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/upload")
@CrossOrigin(origins = "*")
public class FileUploadController {
    
    private static final String UPLOAD_DIR = "/app/uploads/images/";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    @PostMapping("/image")
    public ResponseEntity<Map<String, Object>> uploadImage(@RequestParam("file") MultipartFile file) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 验证文件
            if (file.isEmpty()) {
                response.put("success", false);
                response.put("message", "文件不能为空");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 验证文件大小
            if (file.getSize() > MAX_FILE_SIZE) {
                response.put("success", false);
                response.put("message", "文件大小不能超过5MB");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 验证文件类型
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.put("success", false);
                response.put("message", "只能上传图片文件");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 创建上传目录
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // 生成唯一文件名
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = UUID.randomUUID().toString() + extension;
            
            // 保存文件
            Path filePath = Paths.get(UPLOAD_DIR + filename);
            Files.write(filePath, file.getBytes());
            
            // 返回文件URL
            String fileUrl = "/uploads/images/" + filename;
            response.put("success", true);
            response.put("url", fileUrl);
            response.put("message", "上传成功");
            
            log.info("文件上传成功: {}", fileUrl);
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            log.error("文件上传失败", e);
            response.put("success", false);
            response.put("message", "文件上传失败: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
