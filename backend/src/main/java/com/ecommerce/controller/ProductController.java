package com.ecommerce.controller;

import com.ecommerce.dto.ProductDTO;
import com.ecommerce.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 商品控制器 - RESTful API
 */
@RestController
@RequestMapping(value = "/api/products", produces = "application/json;charset=UTF-8")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ProductController {
    
    static {
        System.setProperty("file.encoding", "UTF-8");
    }
    
    private final ProductService productService;
    
    /**
     * 获取所有商品
     * GET /api/products
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllProducts() {
        List<ProductDTO> products = productService.getAllProducts();
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", products);
        response.put("total", products.size());
        return ResponseEntity.ok(response);
    }
    
    /**
     * 根据ID获取商品详情
     * GET /api/products/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getProductById(@PathVariable Long id) {
        try {
            ProductDTO product = productService.getProductById(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", product);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }
    
    /**
     * 创建商品
     * POST /api/products
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> createProduct(@Valid @RequestBody ProductDTO productDTO) {
        ProductDTO createdProduct = productService.createProduct(productDTO);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", createdProduct);
        response.put("message", "商品创建成功");
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
    
    /**
     * 更新商品
     * PUT /api/products/{id}
     */
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateProduct(
            @PathVariable Long id,
            @Valid @RequestBody ProductDTO productDTO) {
        try {
            ProductDTO updatedProduct = productService.updateProduct(id, productDTO);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", updatedProduct);
            response.put("message", "商品更新成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }
    
    /**
     * 删除商品
     * DELETE /api/products/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteProduct(@PathVariable Long id) {
        try {
            productService.deleteProduct(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "商品删除成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }
    
    /**
     * 根据分类查询商品
     * GET /api/products/category/{category}
     */
    @GetMapping("/category/{category}")
    public ResponseEntity<Map<String, Object>> getProductsByCategory(@PathVariable String category) {
        List<ProductDTO> products = productService.getProductsByCategory(category);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", products);
        response.put("total", products.size());
        return ResponseEntity.ok(response);
    }
    
    /**
     * 搜索商品
     * GET /api/products/search?keyword=xxx
     */
    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchProducts(@RequestParam String keyword) {
        List<ProductDTO> products = productService.searchProducts(keyword);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", products);
        response.put("total", products.size());
        return ResponseEntity.ok(response);
    }
}
