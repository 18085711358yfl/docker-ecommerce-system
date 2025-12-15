package com.ecommerce.service;

import com.ecommerce.dto.ProductDTO;
import com.ecommerce.entity.Product;
import com.ecommerce.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 商品服务层
 */
@Service
@RequiredArgsConstructor
public class ProductService {
    
    private final ProductRepository productRepository;
    
    /**
     * 获取所有商品
     */
    public List<ProductDTO> getAllProducts() {
        return productRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    /**
     * 根据ID获取商品
     */
    public ProductDTO getProductById(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("商品不存在: " + id));
        return convertToDTO(product);
    }
    
    /**
     * 创建商品
     */
    @Transactional
    public ProductDTO createProduct(ProductDTO productDTO) {
        Product product = convertToEntity(productDTO);
        Product savedProduct = productRepository.save(product);
        return convertToDTO(savedProduct);
    }
    
    /**
     * 更新商品
     */
    @Transactional
    public ProductDTO updateProduct(Long id, ProductDTO productDTO) {
        Product existingProduct = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("商品不存在: " + id));
        
        // 手动更新字段以确保所有字段都被正确更新
        existingProduct.setName(productDTO.getName());
        existingProduct.setDescription(productDTO.getDescription());
        existingProduct.setPrice(productDTO.getPrice());
        existingProduct.setStock(productDTO.getStock());
        existingProduct.setCategory(productDTO.getCategory());
        existingProduct.setImageUrl(productDTO.getImageUrl());
        
        Product updatedProduct = productRepository.save(existingProduct);
        return convertToDTO(updatedProduct);
    }
    
    /**
     * 删除商品
     */
    @Transactional
    public void deleteProduct(Long id) {
        if (!productRepository.existsById(id)) {
            throw new RuntimeException("商品不存在: " + id);
        }
        productRepository.deleteById(id);
    }
    
    /**
     * 根据分类查询商品
     */
    public List<ProductDTO> getProductsByCategory(String category) {
        return productRepository.findByCategory(category).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    /**
     * 搜索商品
     */
    public List<ProductDTO> searchProducts(String keyword) {
        return productRepository.findByNameContaining(keyword).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    /**
     * 实体转DTO
     */
    private ProductDTO convertToDTO(Product product) {
        ProductDTO dto = new ProductDTO();
        BeanUtils.copyProperties(product, dto);
        return dto;
    }
    
    /**
     * DTO转实体
     */
    private Product convertToEntity(ProductDTO dto) {
        Product product = new Product();
        BeanUtils.copyProperties(dto, product);
        return product;
    }
}
