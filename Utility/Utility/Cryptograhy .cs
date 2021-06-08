using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
//using Microsoft.AspNetCore.Mvc;

namespace Denver.Infra.Common
{
    public class Cryptograhy
    {
        public EncryptResultModel EncryptText(string input, string password)
        {
            // Get the bytes of the string
            byte[] bytesToBeEncrypted = Encoding.UTF8.GetBytes(input);
            byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
            // Hash the password with SHA256
            passwordBytes = SHA256.Create().ComputeHash(passwordBytes);
            EncryptResultModel ob = AES_Encrypt(bytesToBeEncrypted, passwordBytes);
            return ob;
        }

        public EncryptResultModel EncryptText(string input, string password, string salt)
        {
            // Get the bytes of the string
            byte[] bytesToBeEncrypted = Encoding.UTF8.GetBytes(input);
            byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
            // Hash the password with SHA256
            passwordBytes = SHA256.Create().ComputeHash(passwordBytes);
            EncryptResultModel ob = AES_Encrypt(bytesToBeEncrypted, passwordBytes);
            return ob;
        }

        public string DecryptText(string password, string key, string salt)
        {
            // Get the bytes of the string
            byte[] passwordToBeDecrypted = Convert.FromBase64String(password);
            byte[] keyBytes = Encoding.UTF8.GetBytes(key);

            byte[] salts = Convert.FromBase64String(salt);
            keyBytes = SHA256.Create().ComputeHash(keyBytes);
            EncryptResultModel ob = new EncryptResultModel();

            ob.Password = passwordToBeDecrypted;
            ob.Salt = salts;
            ob.Key = keyBytes;

            EncryptResultModel obj = AES_Decrypt(ob);

            string result = Encoding.UTF8.GetString(obj.Password);

            return result;
        }

        private EncryptResultModel AES_Encrypt(byte[] bytesToBeEncrypted, byte[] passwordBytes)
        {
            byte[] encryptedBytes = null;

            // Set your salt here, change it to meet your flavor:
            // The salt bytes must be at least 8 bytes.
            byte[] saltBytes = GetRandomBytes();

            using (MemoryStream ms = new MemoryStream())
            {
                using (RijndaelManaged AES = new RijndaelManaged())
                {
                    AES.KeySize = 256;
                    AES.BlockSize = 128;

                    var key = new Rfc2898DeriveBytes(passwordBytes, saltBytes, 1000);
                    AES.Key = key.GetBytes(AES.KeySize / 8);
                    AES.IV = key.GetBytes(AES.BlockSize / 8);

                    AES.Mode = CipherMode.CBC;

                    using (var cs = new CryptoStream(ms, AES.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(bytesToBeEncrypted, 0, bytesToBeEncrypted.Length);
                        cs.Close();
                    }
                    encryptedBytes = ms.ToArray();
                }
            }

            return new EncryptResultModel
            {
                Password = encryptedBytes,
                Salt = saltBytes

            };
        }

        public EncryptResultModel AES_Decrypt(EncryptResultModel crpt)
        {
            byte[] decryptedBytes = null;
            byte[] saltBytes = crpt.Salt;
            try
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    using (RijndaelManaged AES = new RijndaelManaged())
                    {
                        AES.KeySize = 256;
                        AES.BlockSize = 128;

                        var key = new Rfc2898DeriveBytes(crpt.Key, saltBytes, 1000);
                        AES.Key = key.GetBytes(AES.KeySize / 8);
                        AES.IV = key.GetBytes(AES.BlockSize / 8);

                        AES.Mode = CipherMode.CBC;

                        using (var cs = new CryptoStream(ms, AES.CreateDecryptor(), CryptoStreamMode.Write))
                        {
                            cs.Write(crpt.Password, 0, crpt.Password.Length);
                            //cs.Close();
                        }
                        decryptedBytes = ms.ToArray();
                    }
                }
            }
            catch (Exception ex)
            {
                return null;
            }

            return new EncryptResultModel
            {
                Password = decryptedBytes,

            };
        }

        private static byte[] GetRandomBytes()
        {
            int saltLength = GetSaltLength();
            byte[] ba = new byte[saltLength];
            RNGCryptoServiceProvider.Create().GetBytes(ba);
            return ba;
        }

        public static int GetSaltLength()
        {
            return 8;
        }
    }

    public class EncryptResultModel
    {
        public byte[] Password { get; set; }
        public byte[] Salt { get; set; }
        public byte[] Key { get; set; }
    }
}
