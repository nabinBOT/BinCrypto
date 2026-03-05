from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

password = b"mypassword123"

key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048
)

pem = key.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.BestAvailableEncryption(password)
)

with open("encrypted_private_key.pem", "wb") as f:
    f.write(pem)

print("Encrypted private key generated!")