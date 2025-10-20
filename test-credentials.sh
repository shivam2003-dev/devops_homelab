#!/bin/bash

echo "🔍 Testing all service credentials..."

# Test Grafana
echo "Testing Grafana (admin/admin)..."
curl -s -u admin:admin http://localhost:3001/api/health > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Grafana: admin/admin - WORKING"
else
    echo "❌ Grafana: admin/admin - FAILED"
fi

# Test Harbor
echo "Testing Harbor (admin/Harbor12345)..."
curl -s -u admin:Harbor12345 http://localhost:8082/api/v2.0/systeminfo > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Harbor: admin/Harbor12345 - WORKING"
else
    echo "❌ Harbor: admin/Harbor12345 - FAILED"
fi

# Test Authelia
echo "Testing Authelia (admin/authelia)..."
curl -s -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"authelia"}' http://localhost:8084/api/firstfactor > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Authelia: admin/authelia - WORKING"
else
    echo "❌ Authelia: admin/authelia - FAILED"
fi

# Test Vault
echo "Testing Vault (token: devops-lab-root-token)..."
curl -s -H "X-Vault-Token: devops-lab-root-token" http://localhost:8200/v1/sys/health > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Vault: token devops-lab-root-token - WORKING"
else
    echo "❌ Vault: token devops-lab-root-token - FAILED"
fi

echo "🎯 Credential testing complete!"
