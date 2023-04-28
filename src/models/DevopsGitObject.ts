import {Field, Model} from 'react3l';

export class DevopsGitObject extends Model {
  @Field(String)
  objectId: string = '';

  @Field(String)
  gitObjectType: 'blob' | 'tree' = 'blob';

  @Field(String)
  commitId: string = '';

  @Field(String)
  path: string = '';

  @Field(Boolean)
  isFolder: boolean = false;

  @Field(String)
  url: string = '';
}
