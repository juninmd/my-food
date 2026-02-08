/**
 * Semantic Release Configuration
 *
 * This configuration handles:
 * 1. Version analysis based on commits.
 * 2. Changelog generation.
 * 3. NPM package version bumping.
 * 4. Flutter pubspec.yaml version bumping and APK building.
 * 5. Git committing of artifacts.
 * 6. GitHub release creation with APK asset.
 */
module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    '@semantic-release/npm',
    [
      '@semantic-release/exec',
      {
        prepareCmd: 'sed -i "s/^version: .*/version: ${nextRelease.version}+${env.GITHUB_RUN_NUMBER}/" pubspec.yaml && flutter build apk --release',
      },
    ],
    [
      '@semantic-release/git',
      {
        assets: ['package.json', 'pubspec.yaml', 'CHANGELOG.md'],
        message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
      },
    ],
    [
      '@semantic-release/github',
      {
        assets: [
          { path: 'build/app/outputs/flutter-apk/app-release.apk', label: 'Android APK' },
        ],
      },
    ],
  ],
};
