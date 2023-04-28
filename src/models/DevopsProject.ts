import {Field, Model} from 'react3l';

class DevOpsProject extends Model {
  @Field(String)
  id: string;

  @Field(String)
  name: string;

  @Field(String)
  url: string;

  @Field(String)
  state: string;

  @Field(Number)
  revision: number;

  @Field(String)
  visibility: string;

  @Field(String)
  lastUpdateTime: string;

  toString(): string {
    return `${this.name} (${this.id})`;
  }
}

export default DevOpsProject;
