import boto3
import os
import sys
import json
from botocore.exceptions import ClientError

def get_s3_clients(region=None):
    session = boto3.session.Session(region_name=region)
    return session.client('s3'), session.resource('s3'), session.region_name

def create_public_bucket(s3, bucket_name, region):
    try:
        if region == 'us-east-1':
            s3.create_bucket(Bucket=bucket_name)
        else:
            s3.create_bucket(
                Bucket=bucket_name,
                CreateBucketConfiguration={'LocationConstraint': region}
            )

        # Disable default public access block for ACLs and policies
        s3.put_public_access_block(
            Bucket=bucket_name,
            PublicAccessBlockConfiguration={
                'BlockPublicAcls': False,
                'IgnorePublicAcls': False,
                'BlockPublicPolicy': False,
                'RestrictPublicBuckets': False
            }
        )

        # Set bucket ACL to public-read (if allowed)
        try:
            s3.put_bucket_acl(Bucket=bucket_name, ACL='public-read')
        except ClientError as acl_error:
            print(f"[!] ACL warning: {acl_error}. Continuing with policy only.")

        # Attach public bucket policy
        public_policy = {
            "Version": "2012-10-17",
            "Statement": [{
                "Sid": "AllowPublicRead",
                "Effect": "Allow",
                "Principal": "*",
                "Action": ["s3:GetObject"],
                "Resource": [f"arn:aws:s3:::{bucket_name}/*"]
            }]
        }

        s3.put_bucket_policy(Bucket=bucket_name, Policy=json.dumps(public_policy))
        print(f"[+] Created public bucket: {bucket_name} in region: {region}")
    except ClientError as e:
        if e.response['Error']['Code'] == 'BucketAlreadyOwnedByYou':
            print(f"[-] Bucket {bucket_name} already exists and is owned by you.")
        elif e.response['Error']['Code'] == 'BucketAlreadyExists':
            print(f"[!] Bucket name {bucket_name} is globally taken. Choose another.")
        else:
            print(f"[!] Bucket creation failed: {e}")
        sys.exit(1)

def upload_file(s3, bucket_name, file_path, region):
    filename = os.path.basename(file_path)
    print(f"[+] Uploading {filename}")
    s3.upload_file(file_path, bucket_name, filename, ExtraArgs={'ACL': 'public-read'})
    url = f"https://{bucket_name}.s3.{region}.amazonaws.com/{filename}"
    print(f"[+] Uploaded: {url}")
    return url

def upload_directory(s3, bucket_name, directory, region):
    urls = []
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path):
            url = upload_file(s3, bucket_name, file_path, region)
            urls.append(url)
    return urls

def delete_bucket_and_contents(s3_resource, bucket_name):
    print(f"[!] Deleting all contents in {bucket_name} and removing bucket...")
    bucket = s3_resource.Bucket(bucket_name)
    bucket.objects.all().delete()
    bucket.object_versions.all().delete()
    bucket.delete()
    print("[+] Bucket deleted.")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="S3 Public Bucket Tool")
    parser.add_argument("--bucket", required=True, help="S3 bucket name to create/use")
    parser.add_argument("--upload-dir", help="Local directory of files to upload")
    parser.add_argument("--upload", nargs='+', help="Individual file(s) to upload")
    parser.add_argument("--region", default=None, help="AWS region to use (e.g., eu-west-1)")
    parser.add_argument("--delete", action='store_true', help="Delete the bucket and contents")

    args = parser.parse_args()

    s3, s3_resource, region = get_s3_clients(args.region)

    if args.delete:
        delete_bucket_and_contents(s3_resource, args.bucket)
    else:
        create_public_bucket(s3, args.bucket, region)
        urls = []
        if args.upload_dir:
            urls.extend(upload_directory(s3, args.bucket, args.upload_dir, region))
        if args.upload:
            for file_path in args.upload:
                if os.path.isfile(file_path):
                    urls.append(upload_file(s3, args.bucket, file_path, region))
                else:
                    print(f"[!] File not found: {file_path}")
        if urls:
            print("\n[+] Public Download URLs:")
            for url in urls:
                print(url)
