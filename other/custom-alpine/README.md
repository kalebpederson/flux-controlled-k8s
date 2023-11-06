oras repo ls is disallowed because it's ttl.sh
oras repo tags ttl.sh/kaleb/98456748971649817436/custom-alpine

this gives us a single type of output -- basic tags (those that we'd expect)
and tags that are added that represent the attestations and signatures that
have been added to the repository.

An example tag:

0.21.0

And example attestations:

sha256-051f6af997df557db3b23f5df318d5127b64122bbbb0b54af89ff00777d33898.att
sha256-1ffe65f368f881941609152041c01150af08bc94bbf62521e281439953299750.att
sha256-377c59dc714850126f217d6c31c78ea2faf912a4c1a83f39343c91e2a70674c9.att
sha256-3814b1b8654f44f1e4a37fd9158e14c251368ecfbb0b14ea8ddecca681ece69b.att
sha256-3e769a18d03fad9737411ef25687358a314386474a1170c61491e53f3ade9b1c.att
sha256-a4ba229e85bbdd05d533c80b210844cecf27f84be154e80ad0722bb667d378c1.att
sha256-c8effde5171da7220c2675d71f6e7bf1ea49b4471691f2a94c2ccd7fd292900c.att
sha256-d74ce17ac32736015092dd815fb1d6d3f1f0a77af161f15fc0a8947876eb05bd.att
sha256-df10be48c6bd16173ed441bf72eb6ecd04f5c7c445b16935c0bdd3f257cab89f.att

And example signatures:

sha256-051f6af997df557db3b23f5df318d5127b64122bbbb0b54af89ff00777d33898.sig
sha256-1ffe65f368f881941609152041c01150af08bc94bbf62521e281439953299750.sig
sha256-377c59dc714850126f217d6c31c78ea2faf912a4c1a83f39343c91e2a70674c9.sig
sha256-3e769a18d03fad9737411ef25687358a314386474a1170c61491e53f3ade9b1c.sig
sha256-a4ba229e85bbdd05d533c80b210844cecf27f84be154e80ad0722bb667d378c1.sig
sha256-c8effde5171da7220c2675d71f6e7bf1ea49b4471691f2a94c2ccd7fd292900c.sig
sha256-d74ce17ac32736015092dd815fb1d6d3f1f0a77af161f15fc0a8947876eb05bd.sig
sha256-df10be48c6bd16173ed441bf72eb6ecd04f5c7c445b16935c0bdd3f257cab89f.sig

If we try to pull the sample attestation, we see that it's an empty file:
oras pull ttl.sh/kaleb/98456748971649817436/custom-alpine:sha256-051f6af997df557db3b23f5df318d5127b64122bbbb0b54af89ff00777d33898.att
Downloaded empty artifact
Pulled [registry] ttl.sh/kaleb/98456748971649817436/custom-alpine:sha256-051f6af997df557db3b23f5df318d5127b64122bbbb0b54af89ff00777d33898.att
Digest: sha256:04722002e153664eddeef7f5bc1c79d0a0dd63b115f3e9ea56950e3eeb54ddde

But that's because the content is in the manifest:



oras manifest fetch --pretty ttl.sh/kaleb/98456748971649817436/custom-alpine:sha256-051f6af997df557db3b23f5df318d5127b64122bbbb0b54af89ff00777d33898.att
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.oci.image.manifest.v1+json",
  "config": {
    "mediaType": "application/vnd.oci.image.config.v1+json",
    "size": 451,
    "digest": "sha256:976cf56532cde41aa4625feee5d0381c43420890edd1b770395872878198dee6"
  },
  "layers": [
    {
      "mediaType": "application/vnd.dsse.envelope.v1+json",
      "size": 103352,
      "digest": "sha256:c6109664bb3d5b7155c9b6fcca9de57e90a7e1842b414c77ebbd4dca127ae4e1",
      "annotations": {
        "dev.cosignproject.cosign/signature": "",
        "predicateType": "https://spdx.dev/Document"
      }
    },
    {
      "mediaType": "application/vnd.dsse.envelope.v1+json",
      "size": 14164,
      "digest": "sha256:f640fdc19cd6fde632625350dfcd4411f01f7734fc19c5d0ae221bb9fb6c9bff",
      "annotations": {
        "dev.cosignproject.cosign/signature": "",
        "predicateType": "https://cosign.sigstore.dev/attestation/vuln/v1"
      }
    },
    {
      "mediaType": "application/vnd.dsse.envelope.v1+json",
      "size": 652,
      "digest": "sha256:718b9b375b3fe4dd5cd6bbb89e123ac0b6fac5235cd30716786cfe911f7ffdbe",
      "annotations": {
        "dev.cosignproject.cosign/signature": "",
        "predicateType": "https://github.com/kalebpederson/schemas/code-coverage"
      }
    }
  ]
}


first, let's get the primary descriptor that describes the image in full
which gives us the primary digest/SHA that represents the tagged image:
 oras manifest fetch --pretty ttl.sh/kaleb/98456748971649817436/custom-alpine:0.21.0 --descriptor
{
 "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
 "digest": "sha256:051f6af997df557db3b23f5df318d5127b64122bbbb0b54af89ff00777d33898",
 "size": 1148
}

using the latest tag, I can retrieve the manifest:
oras manifest fetch --pretty ttl.sh/kaleb/98456748971649817436/custom-alpine:0.21.0
{
 "schemaVersion": 2,
 "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
 "config": {
   "mediaType": "application/vnd.docker.container.image.v1+json",
   "size": 1705,
   "digest": "sha256:31da5bb46f4082a72df79a23db688322dc7a5f2f381d31c32bc45c2f35385953"
 },
 "layers": [
   {
     "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
     "size": 3401967,
     "digest": "sha256:96526aa774ef0126ad0fe9e9a95764c5fc37f409ab9e97021e7b4775d82bf6fa"
   },
   {
     "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
     "size": 90,
     "digest": "sha256:274b69f37ee4c632fcaebe8ed017ec625e894b094580ededad9c696c4489bf53"
   },
   {
     "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
     "size": 161,
     "digest": "sha256:9785918be75a24f10388e3de437876c393c958f1f018a2d3cf82e293d5bde8a8"
   },
   {
     "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
     "size": 175,
     "digest": "sha256:1d40cdf38580f7585dab8f1225f58fb70f311974f6eb4650b64f71bd216f5825"
   }
 ]
}


