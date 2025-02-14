# Find & Publish Teacher Training

This repo is home to three services:

- A service for candidates to [find teacher training](https://www.find-postgraduate-teacher-training.service.gov.uk)
- A service for providers to [publish teacher training courses](https://www.publish-teacher-training-courses.service.gov.uk)
- An API to retrieve data on [teacher training courses](https://api.publish-teacher-training-courses.service.gov.uk/)

## Status

![Build](https://github.com/DFE-Digital/publish-teacher-training/workflows/Build/badge.svg)
[![View performance data on Skylight](https://badges.skylight.io/status/NXAwzyZjkp2m.svg?token=JaYZey50Y8gfC00RvzkcrDz5OP-SwiBSTtbhkMw1KIs)](https://www.skylight.io/app/applications/NXAwzyZjkp2m)

## Table of Contents

- [Environments](#environments)
- [Guides](#guides)
- [License](#license)

## Environments

### New Find (while the migration is in progress)

| Name        | URL                                                                    | Description
| ----------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------------------
| Production  | [www](https://www2.find-postgraduate-teacher-training.service.gov.uk)   | Public site
| Staging     | [staging](https://staging2.find-postgraduate-teacher-training.service.gov.uk)| For internal use by DfE to test deploys
| QA          | [qa](https://qa2.find-postgraduate-teacher-training.service.gov.uk)     | For internal use by DfE for testing. Automatically deployed from main

### Publish

| Name        | URL                                                                | Description
| ----------- | ------------------------------------------------------------------ | ---------------------------------------------------------------------
| Production  | [www](https://www.publish-teacher-training-courses.service.gov.uk) | Public site
| Staging     | [staging](https://staging.publish-teacher-training-courses.service.gov.uk) | For internal use by DfE to test deploys
| QA          | [qa](https://qa.publish-teacher-training-courses.service.gov.uk)  | For internal use by DfE for testing. Automatically deployed from main


## Guides

- [Configuration](/guides/configuration.md)
- [Machine Setup](/guides/machine-setup.md)
- [Setting up the application in development](/guides/setup-development.md)
- [Testing & Linting](/guides/testing.md)
- [Rollover](/guides/rollover.md)
- [API](/guides/api.md)
- [Authentication](/guides/authentication.md)
- [Alerting & Monitoring](/guides/alerting_and_monitoring.md)
- [Transactional Emails](/guides/emails.md)
- [Healthchecks](/guides/healthcheck_and_ping_endpoints.md)
- [Maintenance Mode](/guides/maintenance-mode.md)
- [Disaster Recovery Plan](/guides/disaster-recovery.md)
- [ADRs](/guides/adr/index.md)
- [Support Playbook](/guides/support_playbook.md)


## License

[MIT Licence](LICENCE)
